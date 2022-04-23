//
//  ControlView.swift
//  RealityPlacer V2
//
//  Created by Arnav Singhal on 28/03/22. 
//

import Foundation
import SwiftUI
import RealityKit

struct ControlView: View {
    
    @EnvironmentObject var placementSettings: PlacementSettings
    @EnvironmentObject var deletionManager: DeletionManager
    
    @State var isControlVisible: Bool = true
    @State var isBrowserVisible: Bool = false
    @State var isSettingsVisible: Bool = false
    
    var body: some View {
        VStack {
            controlVisibilityButton
            Spacer()
            if self.placementSettings.selectedModel == nil {
                if isControlVisible {
                    controlButtonBar
                }
            } else {
                PlacementView()
            }
        }
    }
    
    private var controlVisibilityButton: some View {
        HStack {
            Spacer()
            ZStack {
                Color.black.opacity(0.25)
                Button {
                    isControlVisible.toggle()
                } label: {
                    Image(systemName: "dock.rectangle")
                        .font(.largeTitle)
                        .foregroundColor(.white)
                        .buttonStyle(.plain)
                }
            }
            .frame(width: 50, height: 50)
            .cornerRadius(8)
        }
        .padding(.top, 45)
        .padding(.trailing, 20)
    }
    
    private var controlButtonBar: some View {
        
        // Recents button
        HStack(alignment: .center) {
//            Button {
//                print(" DEBUG: Most recent button pressed")
//            } label: {
//                Image(systemName: "clock")
//                    .font(.largeTitle)
//                    .foregroundColor(.white)
//                    .buttonStyle(.plain)
//            }
//            .frame(width: 50, height: 50)
//            Spacer()
             
            // Browse button
            Button {
                isBrowserVisible.toggle()
            } label: {
                Image(systemName: "square.grid.2x2")
                    .font(.largeTitle)
                    .foregroundColor(.white)
                    .buttonStyle(.plain)
            }
            .sheet(isPresented: $isBrowserVisible, content: {
                BrowseView(isBrowseVisible: $isBrowserVisible, isSettingsVisible: $isSettingsVisible)
            })
            .frame(width: 50, height: 50)
            Spacer()
            
            // Settings button
            Button {
                isSettingsVisible.toggle()
            } label: {
                Image(systemName: "slider.horizontal.3")
                    .font(.largeTitle)
                    .foregroundColor(.white)
                    .buttonStyle(.plain)
            }
            .sheet(isPresented: $isSettingsVisible, content: {
                SettingsView(isSettingsVisible: $isSettingsVisible)
            })
            .frame(width: 50, height: 50)
        }
        .frame(maxWidth: 800)
        .padding(30)
        .background(Color.black.opacity(0.25))
    }
}
