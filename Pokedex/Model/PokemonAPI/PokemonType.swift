//
//  PokemonType.swift
//  Pokedex
//
//  Created by t2023-m0072 on 12/30/24.
//

import Foundation

// 포켓몬 타입
struct PokemonType: Decodable {
    
    let english: String?
    
    private(set) lazy var korean: String? = {
        guard let english,
              let pokemonTypeName = PokemonTypeName(rawValue: english) else { return nil }
        
        return pokemonTypeName.displayName
    }()
    
    enum CodingKeys: String, CodingKey {
        case english = "type"
    }
    
}
