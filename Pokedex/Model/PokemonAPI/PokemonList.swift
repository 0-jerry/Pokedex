//
//  PokemonAPI.swift
//  Pokedex
//
//  Created by t2023-m0072 on 12/24/24.
//  https://pokeapi.co/docs/v2#pokemon

import Foundation

// 포켓몬 리스트 데이터 형식
struct PokemonList: Decodable {
    
    let previous: String?
    let next: String?
    let pokemons: [Pokemon]?
    
    enum CodingKeys: String, CodingKey {
        case pokemons = "results"
        case next
        case previous
    }
    
}

