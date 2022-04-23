//
//  DeletionView.swift
//  RealityPlacer V2
//
//  Created by Arnav Singhal on 30/03/22.
//

import Foundation
import SwiftUI

//struct DeletionView: View {
//    @EnvironmentObject var deletionManager: DeletionManager
//
//    var body: some View {
//        HStack {
//            Spacer()
//            DeletionButton(iconName: "xmark.circle") {
//                deletionManager.entitySelectedForDeletion = nil
//            }
//            Spacer()
//            DeletionButton(iconName: "trash.circle") {
//                guard let anchor = deletionManager.entitySelectedForDeletion?.anchor
//                else { return }
//                let anchorAnalyser = anchor.anchorIdentifier
//                if let index = self.sceneManager.anchorEntities.firstIndex(where: { $0.anchorIdentifier == anchorAnalyser}) {
//                    sceneManager.anchorEntities.remove(at: index)
//                }
//                anchor.removeFromParent()
//                deletionManager.entitySelectedForDeletion = nil
//            }
//            Spacer()
//        }
//        .padding(.bottom, 30)
//    }

struct DeletionButton: View {
    let iconName: String
    let action: () -> Void
    
    var body: some View {
        Button {
            action()
        } label: {
            Image(systemName: iconName)
                .font(.largeTitle)
                .foregroundColor(.white)
                .buttonStyle(.plain)
        }
    }
}

