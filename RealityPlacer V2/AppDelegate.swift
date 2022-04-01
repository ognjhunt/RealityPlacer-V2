//
//  AppDelegate.swift
//  RealityPlacer V2
//
//  Created by Arnav Singhal on 28/03/22.
//

import SwiftUI

@main
struct RealityPlacerV2: App {
    
    @StateObject var placementSettings = PlacementSettings()
    @StateObject var sessionSettings = SessionSettings()
    @StateObject var deletionManager = DeletionManager()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(placementSettings)
                .environmentObject(sessionSettings)
                .environmentObject(deletionManager)
        }
    }
}

