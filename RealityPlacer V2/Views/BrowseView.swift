//
//  BrowseView.swift
//  RealityPlacer V2
//
//  Created by Arnav Singhal on 28/03/22.
//

import Foundation
import SwiftUI

struct BrowseView: View {
    
    @Binding var isBrowseVisible: Bool
    @Binding var isSettingsVisible: Bool
    
    var body: some View {
        NavigationView {
            ScrollView(showsIndicators: false) {
                ModelCategoryGrid(isBrowseVisible: $isBrowseVisible)
            }
            .navigationBarTitle(Text("Browse"), displayMode: .large)
            .navigationBarItems(trailing: closeButton)
        }
    }
    
    private var closeButton: some View {
        Button {
            isBrowseVisible.toggle()
        } label: {
            Text("Done")
                .fontWeight(.bold)
        }
    }
}
