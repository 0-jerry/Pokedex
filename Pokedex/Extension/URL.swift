//
//  URL.swift
//  Pokedex
//
//  Created by t2023-m0072 on 12/30/24.
//

import Foundation

extension URL {
    
    init?(from string: String?) {
        guard let string,
              let url = URL(string: string) else { return nil }
        
        self = url
    }
    
}

