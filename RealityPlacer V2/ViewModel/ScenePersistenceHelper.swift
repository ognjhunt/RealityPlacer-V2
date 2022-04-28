//
//  ScenePersistenceHelper.swift
//  RealityPlacer V2
//
//  Created by Arnav Singhal on 25/04/22.
//

import Foundation
import RealityKit
import SwiftUI
import ARKit

class ScenePersistenceHelper {
    
    class func saveScene (for arView: CustomARView, at persistenceURL: URL) {
        print("DEBUG: Saved scene")
        arView.session.getCurrentWorldMap { worldMap, error in
            guard let map = worldMap else {
                return
            }
            do {
                let sceneData = try NSKeyedArchiver.archivedData(withRootObject: map, requiringSecureCoding: true)
                try sceneData.write(to: persistenceURL, options: [.atomic])
            } catch {
                print("DEBUG: Error saving the scene to disk")
            }
        }
    }
    
    class func loadScene (for arView: CustomARView, on scenePersistenceData: Data) {
        print("DEBUG: Load scene")
        let worldMap: ARWorldMap = {
            do {
                guard let worldMap = try NSKeyedUnarchiver.unarchivedObject(ofClass: ARWorldMap.self, from: scenePersistenceData)
                else {
                    fatalError("Persistence Error: No ARWorldMap in archive")
                }
                return worldMap
            } catch {
                fatalError("Persistence Error: No ARWorldMap in Archive #2")
            }
        }()
        
        let newConfig = arView.defaultConfig
        newConfig.initialWorldMap = worldMap
        arView.session.run(newConfig, options: [.resetTracking, .removeExistingAnchors])
    }
}
