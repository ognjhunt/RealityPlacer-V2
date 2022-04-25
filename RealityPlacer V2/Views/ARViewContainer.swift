//
//  ARViewContainer.swift
//  RealityPlacer V2
//
//  Created by Arnav Singhal on 01/04/22.
//

import Foundation
import SwiftUI
import RealityKit
import ARKit

private let anchorNamePrefix = "model-"

struct ARViewContainer: UIViewRepresentable {
    @EnvironmentObject var placementSettings: PlacementSettings
    @EnvironmentObject var sessionSettings: SessionSettings
    @EnvironmentObject var deletionManager: DeletionManager
    @EnvironmentObject var sceneManager: SceneManager
    @EnvironmentObject var viewModel: ModelViewModel
    
    func makeUIView(context: Context) -> CustomARView {
         
        let arView = CustomARView (frame: .zero, sessionSettings: sessionSettings, deletionManager: deletionManager)
        
        arView.session.delegate = context.coordinator
         
        placementSettings.sceneObserver = arView.scene.subscribe(to: SceneEvents.Update.self, { (event) in
            updateScene(for: arView)
            updatePersistanceAvailability(for: arView)
            handlePersistence(for: arView)
        })
        return arView
        
    }
    
    func updateUIView(_ uiView: CustomARView, context: Context) { }
    
    private func updateScene(for arView: CustomARView) {
        arView.focusEntity?.isEnabled = placementSettings.selectedModel != nil
        if let modelAnchor = placementSettings.modelsConfirmedForPlacement.popLast(),
            let modelEntity = modelAnchor.model.modelEntity {
            if let anchor = modelAnchor.anchor {
                self.placeObject(modelEntity, for: anchor, in: arView)
            } else if let transform = getTransformForPlacement(in: arView) {
                let anchorName = anchorNamePrefix + modelAnchor.model.name
                let anchor = ARAnchor(name: anchorName, transform: transform)
                self.placeObject(modelEntity, for: anchor, in: arView)
                arView.session.add(anchor: anchor)
                placementSettings.recentlyPlaced.append(modelAnchor.model)
            }
        }
    }
    
    private func placeObject(_ modelEntity: ModelEntity, for anchor: ARAnchor, in arView: ARView) {
        let cloneEntity = modelEntity.clone(recursive: true)
        cloneEntity.generateCollisionShapes(recursive: true)
        arView.installGestures([.translation, .rotation, .scale], for: cloneEntity)
        let anchorEntity = AnchorEntity(plane: .any)
        anchorEntity.addChild(cloneEntity)
        anchorEntity.anchoring = AnchoringComponent(anchor)
        arView.scene.addAnchor(anchorEntity)
        sceneManager.anchorEntities.append(anchorEntity)
        print("DEBUG: Added the model to the scene")
    }
    
    private func getTransformForPlacement(in arView: ARView) -> simd_float4x4? {
        guard let query = arView.makeRaycastQuery(from: arView.center, allowing: .estimatedPlane, alignment: .any) else {
            return nil
        }
        guard let raycastResult = arView.session.raycast(query).first else {
            return nil
        }
        return raycastResult.worldTransform
    }
}


// MARK: Storage

class SceneManager: ObservableObject {
    @Published var isPersistenceAvailable: Bool = false
    @Published var anchorEntities: [AnchorEntity] = []
    
    var shouldSaveSceneToSystem: Bool = false
    var shouldLoadSceneToSystem: Bool = false
    
    lazy var persistenceURL: URL = {
        do {
            return try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true).appendingPathComponent("arf.persistence")
        } catch {
            fatalError("Unable to get persistence url: \(error.localizedDescription)")
        }
    }()
    
    var scenePersistenceData: Data? {
        return try? Data(contentsOf: persistenceURL)
    }
}

extension ARViewContainer {
    
    private func handlePersistence(for arView: CustomARView) {
        if sceneManager.shouldSaveSceneToSystem {
            ScenePersistenceHelper.saveScene(for: arView, at: sceneManager.persistenceURL)
            sceneManager.shouldSaveSceneToSystem = false
        } else if sceneManager.shouldLoadSceneToSystem {
            guard let scenePersistenceData = sceneManager.scenePersistenceData else {
                print("DEBUG: No persistence data found")
                sceneManager.shouldLoadSceneToSystem = false
                return
            }
            viewModel.clearModelEntitiesFromMemory()
            sceneManager.anchorEntities.removeAll(keepingCapacity: true)
            ScenePersistenceHelper.loadScene(for: arView, on: scenePersistenceData)
            sceneManager.shouldLoadSceneToSystem = false
        }
    }
    
    private func updatePersistanceAvailability(for arView: CustomARView) {
        guard let currentFrame = arView.session.currentFrame else {
            print("DEBUG: Persistence for ARView isnt available rn")
            return
        }
        switch currentFrame.worldMappingStatus {
        case .extending, .mapped:
            self.sceneManager.isPersistenceAvailable = !self.sceneManager.anchorEntities.isEmpty
        default:
            self.sceneManager.isPersistenceAvailable = false
        }
    }
    
    private func saveCurrentWorldMap(for arView: CustomARView) {
        
    }
}

// MARK: AR Coordinator

extension ARViewContainer {
    class Coordinator: NSObject, ARSessionDelegate {
        var parent: ARViewContainer
        
        init(_ parent: ARViewContainer) {
            self.parent = parent
        }
        
        func session(_ session: ARSession, didAdd anchor: [ARAnchor]) {
            for anchor in anchor {
                if let anchorName = anchor.name, anchorName.hasPrefix(anchorNamePrefix) {
                    let modelName = anchorName.dropFirst(anchorNamePrefix.count)
                    print("DEBUG: didAdd function for modelName = \(modelName)")
                    guard let model = self.parent.viewModel.models.first(where: { $0.name == modelName }) else {
                        print("DEBUG: Unable to retrieve model")
                        return
                    }
                    if model.modelEntity == nil {
                        model.asyncLoad { completed, error in
                            if completed {
                                let modelAnchor = ModelAnchor(model: model, anchor: anchor)
                                self.parent.placementSettings.modelsConfirmedForPlacement.append(modelAnchor)
                                print("DEBUG: Adding modelAnchor with name: \(model.name)")
                            }
                        }
                    }
                }
            }
        }
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }
}
