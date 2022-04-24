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

struct ARViewContainer: UIViewRepresentable {
    @EnvironmentObject var placementSettings: PlacementSettings
    @EnvironmentObject var sessionSettings: SessionSettings
    @EnvironmentObject var deletionManager: DeletionManager
    @EnvironmentObject var sceneManager: SceneManager
    
    func makeUIView(context: Context) -> CustomARView {
         
        let arView = CustomARView (frame: .zero, sessionSettings: sessionSettings, deletionManager: deletionManager)
        placementSettings.sceneObserver = arView.scene.subscribe(to: SceneEvents.Update.self, { (event) in
            updateScene(for: arView)
        updatePersistanceAvailability(for: arView)
        })
        return arView
        
    }
    
    func updateUIView(_ uiView: CustomARView, context: Context) { }
    
    private func updateScene(for arView: CustomARView) {
        arView.focusEntity?.isEnabled = placementSettings.selectedModel != nil
        if let confirmedModel = placementSettings.confirmedModel, let modelEntity = confirmedModel.modelEntity {
            placeObject(modelEntity: modelEntity, arView: arView)
            placementSettings.confirmedModel = nil
        }
    }
    
    private func placeObject(modelEntity: ModelEntity, arView: ARView) {
        let cloneEntity = modelEntity.clone(recursive: true)
        cloneEntity.generateCollisionShapes(recursive: true)
        arView.installGestures([.translation, .rotation, .scale], for: cloneEntity)
        let anchorEntity = AnchorEntity(plane: .any)
        anchorEntity.addChild(cloneEntity)
        arView.scene.addAnchor(anchorEntity)
        sceneManager.anchorEntities.append(anchorEntity)
        print("DEBUG: Added the model to the scene")
    }
}


// MARK: Storage

class SceneManager: ObservableObject {
    @Published var isPersistenceAvailable: Bool = false
    @Published var anchorEntities: [AnchorEntity] = []
}

extension ARViewContainer {
    private func updatePersistanceAvailability(for arvView: ARView) {
        guard let currentFrame = arvView.session.currentFrame else {
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
}
