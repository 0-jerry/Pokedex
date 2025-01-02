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
    
    private let pokemonsSubject = PublishSubject<[Pokemon]>()
    
    var pokemons: Observable<[Pokemon]> {
        return pokemonsSubject.asObservable()
    }
    
    private var pokemonList: PokemonList?
            
    private let disposeBag = DisposeBag()
    
    init() {}
    
    func fetchPokeList() {
        if pokemonList == nil {
            fetchFirstPokeList()
        } else {
            fetchNewPokeList()
        }
    }
    
    private func fetchFirstPokeList() {
        pokemonAPIManager
            .fetchPokemonList(limit: 20, offset: 0)?
            .subscribe(onSuccess: { [weak self] pokemonList in
                self?.publishPokemons(pokemonList)
            }
            ).disposed(by: disposeBag)
    }
    
    private func fetchNewPokeList() {
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
