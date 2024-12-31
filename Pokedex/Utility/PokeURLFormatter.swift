//
//  PokeURLFormatter.swift
//  Pokedex
//
//  Created by t2023-m0072 on 12/23/24.
//

import Foundation

/// Poke URL Formatter
///
struct PokeURLFormatter {
    
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
    
    /// PokemonList URL
    static func list(limit: Int, offset: Int) -> URL? {
        guard let listURL = URL(string: "https://pokeapi.co/api/v2/pokemon?limit=\(limit)&offset=\(offset)") else { return nil }
        
        return listURL
    }
    
    /// PokemonList previous URL
    static func previous(of pokeList: PokemonList) -> URL? {
        guard let previous = pokeList.previous,
              let previousURL = URL(string: previous) else { return nil }
        
        return previousURL
    }
    
    /// PokemonList next URL
    static func next(of pokeList: PokemonList) -> URL? {
        guard let next = pokeList.next,
              let nextURL = URL(string: next) else { return nil }
        
        return nextURL
    }
    
}
