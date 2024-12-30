//
//  PokemonAPIManager.swift
//  Pokedex
//
//  Created by t2023-m0072 on 12/29/24.
//

import Foundation
import RxSwift
import Kingfisher
import UIKit

class PokemonAPIManager {
    
    static let shared = PokemonAPIManager()
    
    private let networkManager = NetworkManager.shared
    
    private init() {}
    
    func fetchPokemonList(limit: Int, offset: Int) -> Single<PokemonList>? {
        guard let url = PokeFormatter.list(limit: limit, offset: offset) else { return nil }
        return networkManager.fetch(url: url)
    }
    
    func fetchPokemonDetails(of id: Int) -> Single<PokemonDetails>? {
        guard let url = PokeFormatter.detail(of: id) else { return nil }
        return networkManager.fetch(url: url)
    }
    
    func fetchPokemonImage(of id: Int) -> Single<Data>? {
        guard let url = PokeFormatter.image(of: id) else { return nil }
        return networkManager.fetchImage(url: url)
    }
    
}
