//
//  Untitled.swift
//  Pokedex
//
//  Created by t2023-m0072 on 1/5/25.
//


import UIKit

class ImageCache {
    
    static let shared = ImageCache()
        
    private init() {}
    
    func setImage(_ image: UIImage, forKey url: URL) {
        UserDefaults.standard.setValue(image, forKey: key(url))
    }
    
    func image(forKey url: URL) -> UIImage? {
        UserDefaults.standard.object(forKey: key(url)) as? UIImage
    }
    
    private func key(_ url: URL) -> String {
        return "imageCache: " + url.absoluteString
    }
}
