//
//  SessionSettings.swift
//  RealityPlacer V2
//
//  Created by Arnav Singhal on 29/03/22.
//

import Foundation
import SwiftUI
import RealityKit
import Combine

class SessionSettings: ObservableObject {
    @Published var isPeopleOcculisionEnabled: Bool = false
    @Published var isObjectOcculisionEnabled: Bool = false
    @Published var isLidarEnabled: Bool = false
    @Published var isMultiUserEnabled: Bool = false
}
