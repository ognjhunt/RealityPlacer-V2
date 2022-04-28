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
    @EnvironmentObject var sceneManager: SceneManager
    @EnvironmentObject var viewModel: ModelViewModel
    
    @State var isBrowserVisible: Bool = false
    @State var isSettingsVisible: Bool = false
    @State var selectedControlMode: Int = 0
    
    var body: some View {
        VStack {
            Spacer()
            if self.deletionManager.entitySelectedForDeletion != nil {
                DeletionView()
            } else {
                if self.placementSettings.selectedModel == nil {
                    ControlModePicker(selectedControlMode: $selectedControlMode)
                    if selectedControlMode == 0 {
                        HomeControlView(isBrowserVisible: $isBrowserVisible, isSettingsVisible: $isSettingsVisible)
                    } else {
                        SceneControlView(sceneManager: _sceneManager)
                    }
                } else {
                    PlacementView()
                }
            }
        }
        .onAppear() {
            viewModel.fetchData()
        }
    }
}

// MARK: Main Control View
enum ControlMode: String, CaseIterable {
    case home, scene
}

struct ControlModePicker: View {
    
    @Binding var selectedControlMode: Int
    
    let controlModes = ControlMode.allCases
    
    init(selectedControlMode: Binding<Int>) {
        self._selectedControlMode = selectedControlMode
        UISegmentedControl.appearance().selectedSegmentTintColor = .clear
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor(.yellow)], for: .selected)
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor(.white)], for: .normal)
        UISegmentedControl.appearance().backgroundColor = UIColor(Color.black.opacity(0.25))
    }
    
    var body: some View {
        Picker(selection: $selectedControlMode, label: Text("Select Control Mode")) {
            ForEach(0..<controlModes.count, id: \.self) { index in
                Text(controlModes[index].rawValue.uppercased()).tag(index)
            }
        }
        .pickerStyle(.segmented)
        .frame(maxWidth: 400)
        .padding(.horizontal, 10)
    }
}

// MARK: Home Control View
struct HomeControlView: View {
    
    @EnvironmentObject var placementSettings: PlacementSettings
    
    @Binding var isBrowserVisible: Bool
    @Binding var isSettingsVisible: Bool
    
    var body: some View {
        HStack(alignment: .center) {
            
            // Browse button
            Button {
                isBrowserVisible.toggle()
            } label: {
                Image(systemName: "square.grid.2x2")
                    .font(.title)
                    .foregroundColor(.white)
                    .buttonStyle(.plain)
            }
            .sheet(isPresented: $isBrowserVisible, content: {
                BrowseView(isBrowseVisible: $isBrowserVisible, isSettingsVisible: $isSettingsVisible)
                    .environmentObject(placementSettings)
            })
            .frame(width: 50, height: 50)
            Spacer()
            
            // Screenshot button
            Button {
                print("DEBUG: Screenshot button pressed")
            } label: {
                Image(systemName: "camera")
                    .font(.title)
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
                    .font(.title)
                    .foregroundColor(.white)
                    .buttonStyle(.plain)
            }
            .sheet(isPresented: $isSettingsVisible, content: {
                SettingsView(isSettingsVisible: $isSettingsVisible)
            })
            .frame(width: 50, height: 50)
        }
        .frame(maxWidth: 800)
        .padding(18)
        .background(Color.black.opacity(0.25))
    }
}

// MARK: Scene Control View
struct SceneControlView: View {
    
    @EnvironmentObject var sceneManager: SceneManager
    
    var body: some View {
        
        HStack(alignment: .center) {
            // Save scene button
            if sceneManager.isPersistenceAvailable {
                Button {
                    sceneManager.shouldSaveSceneToSystem = true
                    print("DEBUG: Save scene button clicked")
                    let impactMed = UIImpactFeedbackGenerator(style: .heavy)
                    impactMed.impactOccurred()
                } label: {
                    Image(systemName: "square.and.arrow.down")
                        .font(.title)
                        .foregroundColor(.white)
                        .buttonStyle(.plain)
                }
                .frame(width: 50, height: 50)
                Spacer()
            }
            
            // Load scene button
            if (sceneManager.scenePersistenceData != nil) {
                Button {
                    sceneManager.shouldLoadSceneToSystem = true
                    print("DEBUG: Load scene button pressed")
                    let impactMed = UIImpactFeedbackGenerator(style: .heavy)
                    impactMed.impactOccurred()
                } label: {
                    Image(systemName: "square.and.arrow.up")
                        .font(.title)
                        .foregroundColor(.white)
                        .buttonStyle(.plain)
                }
                .frame(width: 50, height: 50)
                Spacer()
            }
            
            // Delete button
            Button {
                print("DEBUG: Delete scene button pressed")
                for anchorEntity in sceneManager.anchorEntities {
                    anchorEntity.removeFromParent()
                }
                let impactMed = UIImpactFeedbackGenerator(style: .heavy)
                impactMed.impactOccurred()
            } label: {
                Image(systemName: "trash")
                    .font(.title)
                    .foregroundColor(.white)
                    .buttonStyle(.plain)
            }
            .frame(width: 50, height: 50)
        }
        .frame(maxWidth: 800)
        .padding(18)
        .background(Color.black.opacity(0.25))
    }
}
