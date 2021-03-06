//
//  DeletionView.swift
//  RealityPlacer V2
//
//  Created by Arnav Singhal on 30/03/22.
//

import Foundation
import SwiftUI

struct DeletionView: View {
    
    @EnvironmentObject var deletionManager: DeletionManager
    @EnvironmentObject var sceneManager: SceneManager

    var body: some View {
        HStack {
            DeletionButton(iconName: "xmark.circle") {
                deletionManager.entitySelectedForDeletion = nil
            }
            Spacer()
            DeletionButton(iconName: "trash.circle") {
                guard let anchor = deletionManager.entitySelectedForDeletion?.anchor
                else { return }
                let anchorAnalyser = anchor.anchorIdentifier
                if let index = self.sceneManager.anchorEntities.firstIndex(where: { $0.anchorIdentifier == anchorAnalyser}) {
                    sceneManager.anchorEntities.remove(at: index)
                }
                anchor.removeFromParent()
                deletionManager.entitySelectedForDeletion = nil
            }
        }
        .padding(.all, 30)
    }
}

struct DeletionButton: View {
    
    let iconName: String
    let action: () -> Void
    
    var body: some View {
        Button {
            action()
            let impactMed = UIImpactFeedbackGenerator(style: .heavy)
            impactMed.impactOccurred()
        } label: {
            Image(systemName: iconName)
                .font(.largeTitle)
                .foregroundColor(.white)
                .buttonStyle(.plain)
        }
        .frame(width: 75, height: 75)
    }
}

