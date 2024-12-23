//
//  PokeURLFormatter.swift
//  Pokedex
//
//  Created by t2023-m0072 on 12/23/24.
//

import Foundation


/// Poke URL Formatter
///
struct PokeFormatter {
    
    /// Poke Image URL
    static func image(of id: Int) -> URL? {
        guard let pokeImageURL = URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/\(id).png") else { return nil }
        
        return pokeImageURL
    }
    
    /// Poke Detail URL
    static func detail(of id: Int) -> URL? {
        guard let pokeDetailURL = URL(string: "https://pokeapi.co/api/v2/pokemon/\(id)/") else { return nil }
        
        return pokeDetailURL
    }
}


