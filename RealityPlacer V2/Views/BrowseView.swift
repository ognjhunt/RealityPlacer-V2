//
//  BrowseView.swift
//  RealityPlacer V2
//
//  Created by Arnav Singhal on 28/03/22.
//

import Foundation
import SwiftUI

struct BrowseView: View {
    
    var body: some View {
        NavigationView {
            ScrollView(showsIndicators: false) {
                ModelCategoryGrid()
            }
            .navigationBarTitle(Text("Browse"), displayMode: .large)
        }
    }
}
