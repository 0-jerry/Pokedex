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
    
    private var pokemonList: PokemonList?
    
    private(set) var pokemons = [Pokemon]()
    
    private weak var mainViewController: MainViewController?
    
    private let disposeBag = DisposeBag()
    
    init(mainViewController: MainViewController) {
        self.mainViewController = mainViewController
        self.fetchFirstPokeList()
    }
    
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
            .subscribe(
                onSuccess: { [weak self] pokemonList in
                    self?.updatePokeList(pokemonList)
                },
                onFailure: { [weak self] error in
                    switch error {
                    case NetworkManagerError.decodeFailed:
                        self?.mainViewController?
                            .presentErroAlert(error, completion: nil)
                    default:
                        self?.mainViewController?
                            .presentErroAlert(error, completion: self?.fetchFirstPokeList)
                    }
                }
            ).disposed(by: disposeBag)
    }
    
    private func fetchNewPokeList() {
        guard let pokemonList else { return }
        pokemonAPIManager
            .fetchNextPokemonList(pokemonList)?
            .subscribe(
                onSuccess: { [weak self] pokemonList in
                    self?.updatePokeList(pokemonList)
                },
                onFailure: { [weak self] error in
                    switch error {
                    case NetworkManagerError.decodeFailed:
                        self?.mainViewController?
                            .presentErroAlert(error, completion: nil)
                    default:
                        self?.mainViewController?
                            .presentErroAlert(error, completion: self?.fetchNewPokeList)
                    }
                }
            ).disposed(by: disposeBag)
    }
    
    private func updatePokeList(_ pokemonList: PokemonList) {
        self.pokemonList = pokemonList
        
        if let pokemons = pokemonList.pokemons {
            self.pokemons += pokemons
        }
        
        self.mainViewController?.viewReload()
    }
}
