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

class PlacementSettings: ObservableObject {
    @Published var selectedModel: Model? {
        willSet(newValue) {
            print("DEBUG: Selected model for placementSettings is", newValue?.name ?? "nil")
        }
    }
    
    @Published var confirmedModel: Model? {
        willSet(newValue) {
            guard let model = newValue else {
                print("DEBUG: Clearing confirmed model")
                return
            }
            print("DEBUG: Confirmed model for placementSettings is", model.name)
            recentlyPlaced.append(model)
        }
    }
    
    @Published var recentlyPlaced: [Model] = []
    
    var sceneObserver: Cancellable?
}
