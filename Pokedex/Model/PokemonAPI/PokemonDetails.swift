//
//  PokemonDetails.swift
//  Pokedex
//
//  Created by t2023-m0072 on 12/30/24.
//

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
