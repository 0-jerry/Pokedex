//
//  NetworkCache.swift
//  Pokedex
//
//  Created by t2023-m0072 on 1/5/25.
//

import Foundation

final class NetworkCache {
    
    private let dataCache: DataCache
    
    static let shared = NetworkCache()
    
    private init() {
        self.dataCache = DataCache.shared
    }
    
    private func key(_ url: URL) -> String {
        "NetworkManagerDataCache" + url.absoluteString
    }
    
    func data(forKey url: URL) -> Data? {
        dataCache.data(forKey: key(url))
    }
    
    func setData(_ data: Data, forKey url: URL) {
        dataCache.setData(data, forKey: key(url))
    }
    
}
