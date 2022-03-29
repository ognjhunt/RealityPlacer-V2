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
    case Decoration
    case Toys
    case MusicalInstruments
    case Shoes
    case Automobile
    case Extras
    
    var label: String {
        get {
            switch self {
            case .Furniture:
                return "Furniture"
            case .Decoration:
                return "Decoration"
            case .Toys:
                return "Toys"
            case .MusicalInstruments:
                return "Musical Instruments"
            case .Shoes:
                return "Shoes"
            case .Automobile:
                return "Automobile"
            case .Extras:
                return "Extra"
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
        // For furniture
        let chairSwan = Model(name: "chair_swan", category: .Furniture, scaleCompensation: 1.0)
        let tv = Model(name: "tv_retro", category: .Furniture, scaleCompensation: 1.0)
        self.all = [chairSwan, tv]
        
        // For Decoration
        let flowertulip = Model(name: "flower_tulip", category: .Decoration, scaleCompensation: 1.0)
        let saucer = Model(name: "cup_saucer_set", category: .Decoration, scaleCompensation: 1.0)
        let teapot = Model(name: "teapot", category: .Decoration, scaleCompensation: 1.0)
        self.all = [flowertulip, saucer, teapot]
        
        // For Toys
        let airplane = Model(name: "toy_biplane", category: .Toys, scaleCompensation: 1.0)
        let car = Model(name: "toy_car", category: .Toys, scaleCompensation: 1.0)
        let drummer = Model(name: "toy_drummer", category: .Toys, scaleCompensation: 1.0)
        let robot = Model(name: "toy_robot_vintage", category: .Toys, scaleCompensation: 1.0)
        let slide = Model(name: "slide_stylized", category: .Toys, scaleCompensation: 0.8)
        self.all = [airplane, car, drummer, robot, slide]
        
        // For Musical Instruments
        let fender = Model(name: "fender_stratocaster", category: .MusicalInstruments, scaleCompensation: 1.0)
        let gramophone = Model(name: "gramophone", category: .MusicalInstruments, scaleCompensation: 1.0)
        self.all = [fender, gramophone]
        
        // For Shoes
        let airforce = Model(name: "AirForce", category: .Shoes, scaleCompensation: 1.0)
        let pegasus = Model(name: "PegasusTrail", category: .Shoes, scaleCompensation: 1.0)
        self.all = [airforce, pegasus]
        
        // For Automobile
        let huracan = Model(name: "Huracana", category: .Automobile, scaleCompensation: 1.0)
        self.all = [huracan]
        
        // For Extra
        let solarPanel = Model(name: "solar_panels_stylized", category: .Extras, scaleCompensation: 0.5)
        let wateringCan = Model(name: "wateringcan", category: .Decoration, scaleCompensation: 1.0)
        self.all = [solarPanel, wateringCan]
    }
    
    // This should belong in ViewModel but since its just one function I did'nt do it.
    func get(category: AssetsModel) -> [Model] {
        return all.filter({ $0.category == category })
    }
}
