//
//  AppSettings.swift
//  RealityPlacer V2
//
//  Created by Arnav Singhal on 29/03/22.
//

import Foundation

enum Setting {
    case peopleOcclusion
    case objectOcculusion
    case lidarDebug
    case multiuser
    
    var label: String {
        get {
            switch self {
            case .peopleOcclusion:
                return "Occlusion"
            case .objectOcculusion:
                return "Occlusion"
            case .lidarDebug:
                return "LiDAR"
            case .multiuser:
                return "Multiuser"
            }
        }
    }
    
    var systemIcon: String {
        get {
            switch self {
            case .peopleOcclusion:
                return "person"
            case .objectOcculusion:
                return "cube.box"
            case .lidarDebug:
                return "light.min"
            case .multiuser:
                return "person.2"
            }
        }
    }
}
