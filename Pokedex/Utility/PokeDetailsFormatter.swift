//
//  PokeDetailsFormatter.swift
//  Pokedex
//
//  Created by t2023-m0072 on 12/30/24.
//

import Foundation

struct PokeDetailsFormatter {
    let name: String
    let type: String
    let height: String
    let weight: String
    
    init?(_ pokeDetails: PokemonDetails) {
        guard let name = pokeDetails.name,
              let koreanName = PokemonTranslator.getKoreanName(for: name),
              let id = pokeDetails.id,
              let types = pokeDetails.types,
              let height = pokeDetails.height,
              let weight = pokeDetails.weight else { return nil }
        
        self.name = "No.\(id)  \(koreanName)"
        self.type = "타입: \(types.map { $0.korean }.joined(separator: ", "))"
        self.height = "키: \(Double(height)/10) m"
        self.weight = "몸무게: \(Double(weight)/10) kg"
    }
}
