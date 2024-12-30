//
//  PokemonType.swift
//  Pokedex
//
//  Created by t2023-m0072 on 12/30/24.
//

import Foundation

// 포켓몬 타입
struct PokemonType: Decodable {
    let type: NamedAPIResource?
    var english: String? { type?.name }
    
    var korean: String {
        guard let english,
              let pokemonTypeName = PokemonTypeName(rawValue: english) else { return english ?? "none" }
        
        return pokemonTypeName.displayName
    }
    
}

struct NamedAPIResource: Decodable {
    let name: String
    let url: String
}
