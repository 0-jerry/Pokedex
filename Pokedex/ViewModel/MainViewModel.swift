//
//  MainViewModel.swift
//  Pokedex
//
//  Created by t2023-m0072 on 1/2/25.
//

import Foundation

import RxSwift

final class MainViewModel {
    
    private let pokemonAPIManager = PokemonAPIManager.shared
    private let disposeBag = DisposeBag()
    
    private var pokemonList: PokemonList?
        
    private let pokemonsSubject = BehaviorSubject<[Pokemon]>(value: [])
    
    var pokemons: Observable<[Pokemon]> {
        return pokemonsSubject.asObservable()
    }
    
    init() {
        fetchFirstPokeList()
    }
    
    private func fetchFirstPokeList() {
        pokemonAPIManager
            .fetchPokemonList(limit: 21, offset: 0)?
            .subscribe(onSuccess: { [weak self] pokemonList in
                self?.publishPokemons(pokemonList)
            }
        ).disposed(by: disposeBag)
    }
    
    func fetchNewPokeList() {
        guard let pokemonList else { return }
        pokemonAPIManager
            .fetchNextPokemonList(pokemonList)?
            .subscribe(
                onSuccess: { [weak self] pokemonList in
                    self?.publishPokemons(pokemonList)
                }
            ).disposed(by: disposeBag)
    }
    
    private func publishPokemons(_ pokemonList: PokemonList) {
        self.pokemonList = pokemonList
        
        if let pokemons = pokemonList.pokemons {
            pokemonsSubject.onNext(pokemons)
        }
    }
    
}
