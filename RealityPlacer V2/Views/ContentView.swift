//
//  ContentView.swift
//  RealityPlacer V2
//
//  Created by Arnav Singhal on 28/03/22.
//

import SwiftUI
import RealityKit
import ARKit

struct ContentView : View {
    var body: some View {
        ZStack(alignment: .bottom) {
            ARViewContainer()
            ControlView()
        }
        .edgesIgnoringSafeArea(.all)
    }
}

#if DEBUG
struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(PlacementSettings())
            .environmentObject(SessionSettings())
            .environmentObject(DeletionManager())
            .environmentObject(SceneManager())
    }
}
#endif
