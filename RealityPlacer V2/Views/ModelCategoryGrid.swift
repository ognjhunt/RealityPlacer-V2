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
    
    let models = Models()
    
    var body: some View {
        VStack {
            ForEach(AssetsModel.allCases, id: \.self) { category in
                if let modelsbyCategory = models.get(category: category) {
                    horizontalGrid(isBrowseVisible: $isBrowseVisible, title: category.label, items: modelsbyCategory)
                }
            }
        }
    }
}
