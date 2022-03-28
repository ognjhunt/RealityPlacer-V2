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
                // Grid view for thumbnails
                thumbnailHorizontalList
            }
            .navigationBarTitle(Text("Browse"), displayMode: .large)
        }
    }
    
    private var thumbnailHorizontalList: some View {
        VStack(alignment: .leading) {
            Text("Furniture")
                .font(.title2)
                .fontWeight(.bold)
                .padding(.leading, 20)
                .padding(.top, 10)
            
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHGrid(rows: [GridItem(.fixed(150))], spacing: 30) {
                    ForEach(0..<5) { index in
                        Color(UIColor.secondarySystemFill)
                            .frame(width: 150, height: 150)
                            .cornerRadius(8)
                    }
                }
            }
            .padding(.horizontal, 22)
            .padding(.vertical, 10)
        }
    }
}
