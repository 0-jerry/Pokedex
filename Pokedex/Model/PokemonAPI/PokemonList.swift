//
//  PokemonAPI.swift
//  Pokedex
//
//  Created by t2023-m0072 on 12/24/24.
//  https://pokeapi.co/docs/v2#pokemon

import Foundation

// 포켓몬 리스트 데이터 형식
struct PokemonList: Decodable, CustomStringConvertible {
    var description: String {
        return """
        [PokemonList]
        previous: \(String(describing: previous))
        next: \(next ?? "nil")
        
        \(pokemons.map { $0.description }.joined(separator: "\n\n"))
        """
    }
    
    private let previous: String?
    private let next: String?
    let pokemons: [Pokemon]
    
    var nextURL: URL? { URL(from: next) }
    
    var previousURL: URL? { URL(from: previous) }
    
    enum CodingKeys: String, CodingKey {
        case pokemons = "results"
        case next
        case previous
    }
}

