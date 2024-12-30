//
//  MainViewModel.swift
//  Pokedex
//
//  Created by t2023-m0072 on 12/30/24.
//

import Foundation

import RxSwift

protocol MainViewModel {
    
    func fetchPokemonList(limit: Int, offset: Int) -> Single<PokemonList>?
    
}
