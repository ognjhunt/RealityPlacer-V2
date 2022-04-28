//
//  PlacementSettings.swift
//  RealityPlacer V2
//
//  Created by Arnav Singhal on 29/03/22.
//

import Foundation
import SwiftUI
import RealityKit
import Combine
import ARKit

struct  ModelAnchor {
    var model: Model
    var anchor: ARAnchor?
}

class PlacementSettings: ObservableObject {
    
    @Published var selectedModel: Model? {
        willSet(newValue) {
            print("DEBUG: Selected model for placementSettings is", newValue?.name ?? "nil")
        }
    }
    
    @Published var recentlyPlaced: [Model] = []
    
    var modelsConfirmedForPlacement: [ModelAnchor] = []
    var sceneObserver: Cancellable?
}
