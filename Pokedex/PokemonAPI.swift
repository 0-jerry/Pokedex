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
        //        guard let previous,
        //              let next else { return "[PokemonList]"}
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
    
    private(set) lazy var nextURL: URL? = URL(from: next)
    
    private(set) lazy var previousURL: URL? = URL(from: previous)
    
    enum CodingKeys: String, CodingKey {
        case pokemons = "results"
        case next
        case previous
    }
}

// 포켓몬 간단한 데이터 형식
struct Pokemon: Decodable, CustomStringConvertible {
    
    var description: String {
        guard let name,
              let url else { return "pokemon"}
        return """
        name: \(name)
        url: \(url)
        """
    }
    
    let name: String?
    let url: String?
    
    lazy var id: Int? = {
        guard let url else { return 1 }
        var components = url.components(separatedBy: "/")
        let number = components[components.count - 2]
        guard let id = Int(number) else { return 1 }
        return id
    }()
    
    private(set) lazy var detailsURL: URL? = URL(from: url)
}




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

// 포켓몬 타입
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



private extension URL {
    
    init?(from string: String?) {
        guard let string,
              let url = URL(string: string) else { return nil }
        
        self = url
    }
    
}
