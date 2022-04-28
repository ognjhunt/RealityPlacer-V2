//
//  CustomARView.swift
//  RealityPlacer V2
//
//  Created by Arnav Singhal on 29/03/22.
//

import Foundation
import SwiftUI
import RealityKit
import FocusEntity
import ARKit
import Combine

class CustomARView: ARView {
    
    var focusEntity: FocusEntity?
    var sessionSettings: SessionSettings
    var deletionManager: DeletionManager
    
    var defaultConfig: ARWorldTrackingConfiguration {
        let config = ARWorldTrackingConfiguration()
        config.planeDetection = [.horizontal, .vertical]
        config.isAutoFocusEnabled = true
        config.environmentTexturing = .automatic
        config.wantsHDREnvironmentTextures = true
        if ARWorldTrackingConfiguration.supportsSceneReconstruction(.mesh) {
            config.sceneReconstruction = .mesh
        }
        return config
    }
    
    private var peopleOcclusionCancellable: AnyCancellable?
    private var objectOcclusionCancellable: AnyCancellable?
    private var lidarCancellable: AnyCancellable?
    private var multiuserCancellable: AnyCancellable?
    
    required init(frame frameRect: CGRect, sessionSettings: SessionSettings, deletionManager: DeletionManager) {
        self.sessionSettings = sessionSettings
        self.deletionManager = deletionManager
        super.init(frame: frameRect)
        focusEntity = FocusEntity(on: self, focus: .classic)
        configure()
        setupSubscriber()
        activateSettings()
        objectDeletion()
    }
    
    required init(frame frameRect: CGRect) {
        fatalError("not implemented")
    }
    
    @MainActor required dynamic init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        session.run(defaultConfig)
    }
     
    private func activateSettings() {
        self.updatePeopleOcclusion(isEnabled: sessionSettings.isPeopleOcculisionEnabled)
        self.updateLiDAR(isEnabled: sessionSettings.isLidarEnabled)
        self.updateObjectOcclusion(isEnabled: sessionSettings.isObjectOcculisionEnabled)
        self.updateMultiuser(isEnabled: sessionSettings.isMultiUserEnabled)
    }
        
    private func objectDeletion() {
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(recognise:)))
        addGestureRecognizer(longPressGesture)
    }
    
    @objc func handleLongPress(recognise: UILongPressGestureRecognizer) {
        let location = recognise.location(in: self)
        if let entity = entity(at: location) as? ModelEntity {
            deletionManager.entitySelectedForDeletion = entity
        }
    }
    
    private func setupSubscriber() {
        peopleOcclusionCancellable = sessionSettings.$isPeopleOcculisionEnabled.sink(receiveValue: { [weak self]
            isEnabled in
            self?.updatePeopleOcclusion(isEnabled: isEnabled)
        })
        objectOcclusionCancellable = sessionSettings.$isObjectOcculisionEnabled.sink(receiveValue: { [weak self]
            isEnabled in
            self?.updateObjectOcclusion(isEnabled: isEnabled)
        })
         lidarCancellable = sessionSettings.$isLidarEnabled.sink(receiveValue: { [weak self]
            isEnabled in
            self?.updateLiDAR(isEnabled: isEnabled)
        })
        multiuserCancellable = sessionSettings.$isMultiUserEnabled.sink(receiveValue: { [weak self]
            isEnabled in
            self?.updateMultiuser(isEnabled: isEnabled)
        })
    }
    
    private func updatePeopleOcclusion(isEnabled: Bool) {
        guard ARWorldTrackingConfiguration.supportsFrameSemantics(.personSegmentationWithDepth) else {
            return
        }
        guard let configuration = self.session.configuration as? ARWorldTrackingConfiguration else {
            return
        }
        if configuration.frameSemantics.contains(.personSegmentationWithDepth) {
            configuration.frameSemantics.remove(.personSegmentationWithDepth)
        } else {
            configuration.frameSemantics.insert(.personSegmentationWithDepth)
            print("DEBUG: People occlusion is toggled")
        }
        self.session.run(configuration)
    }
    
    private func updateObjectOcclusion(isEnabled: Bool) {
        if environment.sceneUnderstanding.options.contains(.occlusion) {
            environment.sceneUnderstanding.options.remove(.occlusion)
        } else {
            environment.sceneUnderstanding.options.insert(.occlusion)
            print("DEBUG: Object occlusion is toggled")
        }
    }
    
    private func updateLiDAR(isEnabled: Bool) {
        if debugOptions.contains(.showSceneUnderstanding) {
            debugOptions.remove(.showSceneUnderstanding)
        } else {
            debugOptions.insert(.showSceneUnderstanding)
            print("DEBUG: LIDAR scene understanding is toggled")
        }
    }
    
    private func updateMultiuser(isEnabled: Bool) {
        print("DEBUG: Multiuser is not currently implemented")
    }
}
