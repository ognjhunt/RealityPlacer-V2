//
//  AssetsModel.swift
//  RealityPlacer V2
//
//  Created by Arnav Singhal on 28/03/22.
//

import Foundation
import SwiftUI
import RealityKit
import Combine

enum AssetsModel: CaseIterable {
    case Furniture
    case Toys
    case Music

    var label: String {
        get {
            switch self {
            case .Furniture:
                return "Furniture"
            case .Toys:
                return "Toys"
            case .Music:
                return "Music"
            }
        }
    }
}

class Model {
    var name: String
    var category: AssetsModel
    var thumbnail: UIImage
    var modelEntity: ModelEntity?
    var scaleCompensation: Float
    
    init(name: String, category: AssetsModel, scaleCompensation: Float = 1.0) {
        self.name = name
        self.category = category
        self.thumbnail = UIImage(named: name) ?? UIImage(systemName: "photo")!
        self.scaleCompensation = scaleCompensation
    }
}

struct Models {
    var all: [Model] = []
    init() {
        let chairSwan = Model(name: "chair_swan", category: .Furniture, scaleCompensation: 0.32/100)
        let fender = Model(name: "fender_stratocaster", category: .Music, scaleCompensation: 0.32/100)
        let gramophone = Model(name: "gramophone", category: .Music, scaleCompensation: 0.32/100)
        let plane = Model(name: "toy_biplane", category: .Toys, scaleCompensation: 0.5)
        let tv = Model(name: "tv_retro", category: .Furniture, scaleCompensation: 0.32/100)
        
        self.all += [chairSwan, fender, gramophone, plane, tv]
    }
    
    func get(category: AssetsModel) -> [Model] {
        return all.filter({ $0.category == category })
    }
}
