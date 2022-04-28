//
//  ModelViewModel.swift
//  RealityPlacer V2
//
//  Created by Arnav Singhal on 23/04/22.
//

import Foundation
import FirebaseFirestore

class ModelViewModel: ObservableObject {
    
    @Published var models: [Model] = []
    
    private let db = Firestore.firestore()
    
    func fetchData() {
        db.collection("models").addSnapshotListener { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                print("DEBUG: Nothing get fetched from firebase")
                return
            }
            self.models = documents.map { (queryDocumentSnapshot) -> Model in
                let data = queryDocumentSnapshot.data()
                let name = data["name"] as? String ?? ""
                let categoryText = data["category"] as? String ?? ""
                let category = AssetsModel(rawValue: categoryText) ?? .Extras
                let scaleCompensation = data["scaleCompensation"] as? Double ?? 1.0
                
                return Model(name: name, category: category, scaleCompensation: Float(scaleCompensation))
            }
        }
    }
    
    func clearModelEntitiesFromMemory(){
        for model in models {
            model.modelEntity = nil
        }
    }
}
