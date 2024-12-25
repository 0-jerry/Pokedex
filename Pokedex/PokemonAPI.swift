//
//  PokemonAPI.swift
//  Pokedex
//
//  Created by t2023-m0072 on 12/24/24.
//  https://pokeapi.co/docs/v2#pokemon

import Foundation

// id, 이름, 키, 몸무게, 타입
struct PokemonDetails: Decodable {
    
    let id: Int?
    let name: String?
    let height: Int?
    let weight: Int?
    let types: [PokemonType]?
    
    private(set) lazy var koreanName: String? = {
        guard let name,
              let koreanName = PokemonTranslator.getKoreanName(for: name) else { return nil }
        
        return koreanName
    }()
    
}

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
