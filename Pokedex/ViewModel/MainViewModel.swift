//
//  MainViewModel.swift
//  Pokedex
//
//  Created by t2023-m0072 on 1/2/25.
//

import UIKit

import RxSwift

final class MainViewModel {
    
    private let pokemonAPIManager = PokemonAPIManager.shared
    private let disposeBag = DisposeBag()
    
    private var pokemonList: PokemonList?
        
    private let pokemonsSubject = BehaviorSubject<[Pokemon]>(value: [])
    
    private func fetchFirstPokeList() {
        pokemonAPIManager
            .fetchPokemonList(limit: 21, offset: 0)?
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

extension MainViewModel {
    
    struct Input {
        let viewDidLoad: Single<Void>
        let scrollEndpoint: Observable<Void>
    }
    
    struct Output {
        let pokemons: Observable<[Pokemon]>
    }
    
    func transform(_ input: Input) -> Output {
        let pokemons = pokemonsSubject.asObservable()
                
        input.viewDidLoad
            .subscribe(onSuccess: { [weak self] in
                self?.fetchFirstPokeList()
            }).disposed(by: disposeBag)
        
        input.scrollEndpoint
            .withUnretained(self)
            .subscribe(onNext: { [weak self] _ in
                self?.fetchNewPokeList()
            }).disposed(by: disposeBag)
        
        return Output(pokemons: pokemons)
    }
}
