//
//  PlacementView.swift
//  RealityPlacer V2
//
//  Created by Arnav Singhal on 29/03/22.
//

import Foundation
import SwiftUI

struct PlacementView: View {
    @EnvironmentObject var placementSettings: PlacementSettings
    var body: some View {
        HStack {
            PlacementButton(systemIcon: "xmark.circle") {
                print("DEBUG: Cancelled button pressed")
                placementSettings.selectedModel = nil
            }
            Spacer()
            PlacementButton(systemIcon: "checkmark.circle") {
                print("DEBUG: Confirmed button pressed")
                let modelAnchor = ModelAnchor(model: placementSettings.selectedModel!, anchor: nil)
                placementSettings.modelsConfirmedForPlacement.append(modelAnchor)
                placementSettings.selectedModel = nil
            }
        }
        .padding(.all, 30)
    }
}

struct PlacementButton: View {
    let systemIcon: String
    let action: () -> Void
    var body: some View {
        Button {
            action()
            let impactMed = UIImpactFeedbackGenerator(style: .heavy)
            impactMed.impactOccurred()
        } label: {
            Image(systemName: systemIcon)
                .font(.largeTitle)
                .foregroundColor(.white)
                .buttonStyle(.plain)
        }
        .frame(width: 75, height: 75)
    }
}
