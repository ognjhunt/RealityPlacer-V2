//
//  ScreenshotHelper.swift
//  RealityPlacer
//
//  Created by Arnav Singhal on 28/04/22.
//

import Foundation
import UIKit

class ScreenshotHelper: ObservableObject {
    
    @Published var YesTakeAScreenshoot: Bool = false
    
    @objc func imageWasSaved(_ image: UIImage, error: Error?, context: UnsafeMutableRawPointer) {
        if let error = error {
            print(error.localizedDescription)
            return
        }
    }
    
    class func takeScreenshot(of view: CustomARView) {
        UIGraphicsBeginImageContextWithOptions(
                 CGSize(width: view.bounds.width, height: view.bounds.height),
                 false,
                 2
             )
        view.layer.render(in: UIGraphicsGetCurrentContext()!)
        let screenshot = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        UIImageWriteToSavedPhotosAlbum(screenshot, self, #selector(imageWasSaved), nil)
    }
}
