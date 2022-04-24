//
//  AppDelegate.swift
//  RealityPlacer V2
//
//  Created by Arnav Singhal on 28/03/22.
//

import SwiftUI
import Firebase

@main
struct RealityPlacerV2: App {
    
    @StateObject var placementSettings = PlacementSettings()
    @StateObject var sessionSettings = SessionSettings()
    @StateObject var deletionManager = DeletionManager()
    @StateObject var sceneManager = SceneManager()
    
    init() {
        FirebaseApp.configure()
        
        // Anonymous Auth
        Auth.auth().signInAnonymously { authResult, error in
            guard let user = authResult?.user else {
                print(" DEBUG: Authentication failed for firebase")
                return
            }
            let uid = user.uid
            print("DEBUG: Authentication succesfull with \(uid) as UID")
        }
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(placementSettings)
                .environmentObject(sessionSettings)
                .environmentObject(deletionManager)
                .environmentObject(sceneManager)
        }
    }
}

