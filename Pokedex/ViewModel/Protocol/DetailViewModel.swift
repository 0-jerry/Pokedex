//
//  DetailViewModel.swift
//  Pokedex
//
//  Created by t2023-m0072 on 12/30/24.
//

import Foundation

import RxSwift

protocol DetailViewModel {
    
    func fetchPokemonImage(of id: Int) -> Single<Data>?

    func fetchPokemonDetails(of id: Int) -> Single<PokemonDetails>?

}
