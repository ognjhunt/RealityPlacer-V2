//
//  HorizontalGrid.swift
//  RealityPlacer V2
//
//  Created by Arnav Singhal on 28/03/22.
//

import Foundation
import SwiftUI

struct horizontalGrid: View {
    
    @EnvironmentObject var placementSetting: PlacementSettings
    @Binding var isBrowseVisible: Bool
    
    var title: String
    var items: [Model]
    
    var body: some View {
        VStack(alignment: .leading) {
            Divider()
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
            
            Text(title)
                .font(.title2)
                .fontWeight(.bold)
                .padding(.leading, 20)
                .padding(.top, 10)
            
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHGrid(rows: [GridItem(.fixed(150))], spacing: 30) {
                    ForEach(0..<items.count, id: \.self) { index in
                        let model = items[index]
                        ItemButton(model: model) {
                            placementSetting.selectedModel = model
                            model.asyncLoad() 
                            isBrowseVisible.toggle()
                        }
                    }
                }
            }
            .padding(.horizontal, 22)
            .padding(.vertical, 10)
        }
    }
}

struct ItemButton: View {
    let model: Model
    let action: () -> Void
    
    var body: some View {
        Button {
            action()
        } label: {
            Image(uiImage: model.thumbnail)
                .resizable()
                .frame(height: 150)
                .aspectRatio(1/1, contentMode: .fit)
                .background(Color(UIColor.secondarySystemFill))
                .mask(RoundedRectangle(cornerRadius: 8))
                .shadow(radius: 4)
                .padding(.all,4)
        }
    }
}

