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
    
    func makeUIView(context: Context) -> CustomARView {
         
        let arView = CustomARView (frame: .zero, sessionSettings: sessionSettings, deletionManager: deletionManager)
        placementSettings.sceneObserver = arView.scene.subscribe(to: SceneEvents.Update.self, { (event) in
            updateScene(for: arView)
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
        arView.installGestures([.translation, .rotation], for: cloneEntity)
        let anchorEntity = AnchorEntity(plane: .any)
        anchorEntity.addChild(cloneEntity)
        arView.scene.addAnchor(anchorEntity)
        print("Added the model to the scene")
    }
}

