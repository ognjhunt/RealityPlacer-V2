//
//  ModelCategoryGrid.swift
//  RealityPlacer V2
//
//  Created by Arnav Singhal on 28/03/22.
//

import Foundation
import SwiftUI


struct ModelCategoryGrid: View {
    
    @Binding var isBrowseVisible: Bool
    
    @ObservedObject private var viewModel = ModelViewModel()
    
    var body: some View {
        VStack {
            ForEach(AssetsModel.allCases, id: \.self) { category in
                if let modelsbyCategory = viewModel.models.filter({ $0.category == category}) {
                    horizontalGrid(isBrowseVisible: $isBrowseVisible, title: category.label, items: modelsbyCategory)
                }
            }
        }
        .onAppear() {
            viewModel.fetchData()
        }
    }
}
