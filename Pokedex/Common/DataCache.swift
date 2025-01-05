//
//  Untitled.swift
//  Pokedex
//
//  Created by t2023-m0072 on 1/5/25.
//


import UIKit

class DataCache {
    
    static let shared = DataCache()
        
    private init() {}
    
    private var cache: [String: Data] = [:]
    
    func setData(_ data: Data, forKey key: String) {
        cache[key] = data
    }
    
    func data(forKey key: String) -> Data? {
        return cache[key]
    }
    
}
