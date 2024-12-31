//
//  ViewController.swift
//  Pokedex
//
//  Created by t2023-m0072 on 12/23/24.
//

import UIKit

import RxSwift
import SnapKit

final class MainViewController: UIViewController {
    
    private let mainViewModel: MainViewModel = PokemonAPIManager.shared
    private var pokemonList: PokemonList?
    private var pokemons = [Pokemon]()
    private let disposeBag = DisposeBag()
    private let mainView: MainView = MainView()
    
    override func loadView() {
        super.loadView()
        
        view = self.mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainView.collectionView.dataSource = self
        mainView.collectionView.delegate = self
        
        configureFirstPokeList()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.navigationController?.navigationBar.isHidden = false
    }
    
    private func updatePokemonList(_ pokemonList: PokemonList) {
        self.pokemonList = pokemonList
        self.pokemons += pokemonList.pokemons
        
        DispatchQueue.main.async {
            self.mainView.reloadCollectionView()
        }
    }
    
    private func configureFirstPokeList() {
        guard let single = mainViewModel.fetchPokemonList(limit: 20, offset: 0) else { return }
        
        single.subscribe(
            onSuccess: { [weak self] pokemonList in
                self?.updatePokemonList(pokemonList)
            }
        ).disposed(by: disposeBag)
    }
    
    private func appendPokemons() {
        guard let pokemonList,
        let single = mainViewModel.fetchNextPokemonList(pokemonList) else { return }
        
        single.subscribe(
            onSuccess: { [weak self] pokemonList in
                self?.updatePokemonList(pokemonList)
            }
        ).disposed(by: disposeBag)
    }
    
    private func presentErrorAlert(_ error: Error) {
        let message = error.localizedDescription
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let retry = UIAlertAction(title: "retry", style: .default, handler: { [weak self] _ in
            self?.configureFirstPokeList()
            self?.mainView.reloadCollectionView()
        })
        let cancel = UIAlertAction(title: "cancel", style: .cancel)
        
        alertController.addAction(retry)
        alertController.addAction(cancel)
        
        present(alertController, animated: true)
    }
    
}

extension MainViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pokemons.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let defaultCell = collectionView.dequeueReusableCell(withReuseIdentifier: PokeCollectionViewCell.id, for: indexPath)
        
        guard let pokeCollectionViewCell = defaultCell as? PokeCollectionViewCell else {
            return defaultCell
        }
        let pokemon = pokemons[indexPath.item]
        guard let pokeID = pokemon.id else {
            return defaultCell
        }
        mainViewModel.fetchPokemonImage(of: pokeID)?.subscribe(
            onSuccess: { [weak pokeCollectionViewCell] data in
                pokeCollectionViewCell?.updateImage(by: data)
            }
        ).disposed(by: pokeCollectionViewCell.disposeBag)
        
        return defaultCell
    }
    
}


extension MainViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let pokemon = pokemons[indexPath.item]
        guard let pokeID = pokemon.id else { return }
        
        let detailViewController = DetailViewController()
        detailViewController.configurePokeID(pokeID)
        self.navigationController?.pushViewController(detailViewController, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if pokemons.count - 3 == indexPath.item {
            appendPokemons()
        }
    }
    
}
