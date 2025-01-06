//
//  PokemonType.swift
//  Pokedex
//
//  Created by t2023-m0072 on 12/30/24.
//

import Foundation

/// 포켓몬 타입
///
struct PokemonType: Decodable {
    
    private let type: NamedAPIResource?
    var english: String? { type?.name }
    
}
