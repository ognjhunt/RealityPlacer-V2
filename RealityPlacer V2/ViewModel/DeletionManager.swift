//
//  DeletetionManager.swift
//  RealityPlacer V2
//
//  Created by Arnav Singhal on 30/03/22.
//

import Foundation
import SwiftUI
import RealityKit

class DeletionManager: ObservableObject {
    
    @Published var entitySelectedForDeletion: ModelEntity? = nil {
        
        willSet(newValue) {
            if entitySelectedForDeletion == nil, let newlySelectedModelEntity = newValue {
                let component = ModelDebugOptionsComponent(visualizationMode: .lightingDiffuse)
                newlySelectedModelEntity.modelDebugOptions = component
            } else if let previouslySelectedModelEntity = entitySelectedForDeletion, let newlySelectedModelEnity = newValue {
                previouslySelectedModelEntity.modelDebugOptions = nil
                let component = ModelDebugOptionsComponent(visualizationMode: .lightingDiffuse)
                newlySelectedModelEnity.modelDebugOptions = component
            } else if newValue == nil {
                entitySelectedForDeletion?.modelDebugOptions = nil
            }
        }
    }
}

