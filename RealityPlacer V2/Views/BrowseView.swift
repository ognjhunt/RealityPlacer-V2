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

struct ModelCategoryGrid: View {
    
    @EnvironmentObject var viewModel: ModelViewModel
    @Binding var isBrowseVisible: Bool
    
    var body: some View {
        VStack {
            ForEach(AssetsModel.allCases, id: \.self) { category in
                if let modelsbyCategory = viewModel.models.filter({ $0.category == category}) {
                    horizontalGrid(isBrowseVisible: $isBrowseVisible, title: category.label, items: modelsbyCategory)
                }
            }
        }
    }
}

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
                            model.asyncLoad { completed, error in
                                if completed {
                                    placementSetting.selectedModel = model
                                }
                            }
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
    @ObservedObject var model: Model
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

