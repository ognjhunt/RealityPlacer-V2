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

enum AssetsModel: String, CaseIterable {
    case Furniture
    case Decoration
    case Toys
    case Technology
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
            case .Technology:
                return "Technology"
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

class Model: ObservableObject, Identifiable {
    var name: String
    var id: String = UUID().uuidString
    var category: AssetsModel
    @Published var thumbnail: UIImage
    var modelEntity: ModelEntity?
    var scaleCompensation: Float
    
    var cancellable: AnyCancellable?
    
    init(name: String, category: AssetsModel, scaleCompensation: Float = 1.0) {
        self.name = name
        self.category = category
        self.thumbnail = UIImage(systemName: "photo")!
        self.scaleCompensation = scaleCompensation
        
        FirebaseStorageHelper.asyncDownloadToFilesystem(relativePath: "thumbnails/\(name).png") { localUrl in
            do {
                let imageData = try Data(contentsOf: localUrl)
                self.thumbnail = UIImage(data: imageData) ?? self.thumbnail
            } catch {
                print("DEBUG: Error loading image: \(error.localizedDescription)")
            }
        }
    }
    
    func asyncLoad(handler: @escaping (_ completed: Bool, _ error: Error?) -> Void) {
        FirebaseStorageHelper.asyncDownloadToFilesystem(relativePath: "models/\(self.name).usdz") { localUrl in
            self.cancellable = ModelEntity.loadModelAsync(contentsOf: localUrl)
                .sink { loadCompletion in
                    switch loadCompletion {
                    case .failure(let error):
                        print("DEBUG:", error)
                        handler(false, error)
                    case .finished:
                        break
                    }
                } receiveValue: { [self] modelEntity in
                    self.modelEntity = modelEntity
                    self.modelEntity?.scale *= self.scaleCompensation
                    handler(true, nil)
                    print("DEBUG: Model loaded is ", name)
            }
        }
    }
}
