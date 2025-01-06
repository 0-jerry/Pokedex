//
//  PokemonDetails.swift
//  Pokedex
//
//  Created by t2023-m0072 on 12/30/24.
//

import Foundation

// ID, 이름, 키, 몸무게, 타입
struct PokemonDetails: Decodable {
    
    let id: PokeID?
    let name: String?
    let height: Int?
    let weight: Int?
    let types: [PokemonType]?
    
}

