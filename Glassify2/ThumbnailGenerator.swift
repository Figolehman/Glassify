//
//  ThumbnailGenerator.swift
//  Glassify2
//
//  Created by Figo Alessandro Lehman on 20/05/23.
//

import QuickLookThumbnailing
import SwiftUI
//    import Combine
//import UIKit

class ThumbnailGenerator: ObservableObject {
    @Published var thumbnailImage: Image?
    
    func generateThumbnail(for resource: String, withExtension: String = "usdz", size: CGSize){
        guard let url = Bundle.main.path(forResource: resource, ofType: withExtension)
            
        else{
            print("error in url thumbnail")
            return
        }
        
        let urls = URL(fileURLWithPath: url)
        
        let scale = UIScreen.main.scale
        
        let request = QLThumbnailGenerator.Request(fileAt: urls, size: size, scale: scale, representationTypes: .thumbnail)
        
        let generator = QLThumbnailGenerator.shared
        
        generator.generateBestRepresentation(for: request){ (thumbnail, error) in
            DispatchQueue.main.async {
                if thumbnail == nil || error != nil {
                    print("error generating thumbnail : \(error?.localizedDescription)")
                    return
                }
                else{
                    self.thumbnailImage = Image(uiImage: thumbnail!.uiImage)
                }
            }
        }
    }
}
