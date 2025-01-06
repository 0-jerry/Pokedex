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
              let id = pokeDetails.id,
              let types = pokeDetails.types,
              let height = pokeDetails.height,
              let weight = pokeDetails.weight else { return nil }
        
        let koreanName = PokemonTranslator.getKoreanName(for: name)
        let type = PokemonTypeName.format(types)
        
        self.name = "No.\(id)  \(koreanName)"
        self.type = "타입: \(type)"
        self.height = "키: \(Double(height)/10) m"
        self.weight = "몸무게: \(Double(weight)/10) kg"
    }
    
    init(name: String,
         type: String,
         height: String,
         weight: String) {
        self.name = name
        self.type = type
        self.height = height
        self.weight = weight
    }
    
}
