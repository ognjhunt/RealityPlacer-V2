//
//  SettingsView.swift
//  RealityPlacer V2
//
//  Created by Arnav Singhal on 29/03/22.
//

import Foundation
import SwiftUI

struct SettingsView: View {
    
    @Binding var isSettingsVisible: Bool
    
    var body: some View {
        NavigationView {
            settingsGrid()
                .navigationTitle(Text("Settings"))
                .toolbar {
                    Button {
                        isSettingsVisible.toggle()
                    } label: {
                        Text("Done")
                            .fontWeight(.bold)
                }
            }
        }
    }
}

struct settingsGrid: View {
    
    @EnvironmentObject var sessionSettings: SessionSettings
    
    private var gridItemLayout = [GridItem(.adaptive(minimum: 100, maximum: 100), spacing: 25)]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: gridItemLayout, spacing: 25) {
                toggleButton(setting: .peopleOcclusion, isOn: $sessionSettings.isPeopleOcculisionEnabled)
                toggleButton(setting: .objectOcculusion, isOn: $sessionSettings.isObjectOcculisionEnabled)
                toggleButton(setting: .lidarDebug, isOn: $sessionSettings.isLidarEnabled)
                toggleButton(setting: .multiuser, isOn: $sessionSettings.isMultiUserEnabled)
            }
        }
        .padding(.top, 35)
    }
}

struct toggleButton: View {
    
    let setting: Setting
    
    @Binding var isOn: Bool
    
    var body: some View {
        Button {
            isOn.toggle()
        } label: {
            VStack {
                Image(systemName: setting.systemIcon)
                    .font(.title)
                    .foregroundColor(isOn ? .green : Color(UIColor.secondaryLabel))
                    .buttonStyle(.plain)
                Text(setting.label)
                    .font(.body)
                    .foregroundColor(isOn ? Color(UIColor.label) : Color(UIColor.secondaryLabel))
                    .padding(.top, 5)
            }
            .frame(width: 100, height: 100)
            .background(Color(UIColor.secondarySystemFill))
            .cornerRadius(20)
        }
    }
}
