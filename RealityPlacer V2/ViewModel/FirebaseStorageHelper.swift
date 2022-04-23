//
//  FirebaseStorageHelper.swift
//  RealityPlacer V2
//
//  Created by Arnav Singhal on 23/04/22.
//

import Foundation
import Firebase

class FirebaseStorageHelper {
    static private let cloudStorage = Storage.storage()
    
    class func asyncDownloadToFilesystem(relativePath: String, handler: @escaping (_ fileUrl: URL) -> Void) {
        
        let docsUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileUrl = docsUrl.appendingPathComponent (relativePath)
        
        // Check if asset is already in the local filesystem
        
        if FileManager.default.fileExists(atPath: fileUrl.path){
            handler(fileUrl)
            return
        }
        
        // Create a refercence to the models
        let storageRefs = cloudStorage.reference(withPath: relativePath)
        
        // Download to local file system
        storageRefs.write(toFile: fileUrl) { url, error in
            guard let localUrl = url else {
                print("DEBUG: Error downloading the file to \(relativePath)")
                return
            }
            handler(localUrl)
        }
        .resume()
    }
}
