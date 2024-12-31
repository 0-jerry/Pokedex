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
        
        updatePokemons()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.navigationController?.navigationBar.isHidden = false
    }
    
    private func updatePokemons() {
        guard let single = mainViewModel.fetchPokemonList(limit: 20, offset: 0) else { return }
        
        single.subscribe(
            onSuccess: { [weak self] pokemonList in
            self?.pokemonList = pokemonList
            
            DispatchQueue.main.async {
                self?.mainView.reloadCollectionView()
            }
        }).disposed(by: disposeBag)
    }
    
}

extension MainViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        pokemonList?.pokemons.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let defaultCell = collectionView.dequeueReusableCell(withReuseIdentifier: PokeCollectionViewCell.id, for: indexPath)
        
        guard let pokeCollectionViewCell = defaultCell as? PokeCollectionViewCell else {
            return defaultCell
        }
        
        guard let pokemon = pokemonList?.pokemons[indexPath.item],
              let id = pokemon.id else {
            return defaultCell
        }
        
        mainViewModel.fetchPokemonImage(of: id)?.subscribe(
            onSuccess: { data in
                pokeCollectionViewCell.updateImage(by: data)
            }
        ).disposed(by: disposeBag)
        
        return defaultCell
    }
    
}


extension MainViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let pokemon = pokemonList?.pokemons[indexPath.item],
              let id = pokemon.id else { return }
        
        let detailViewController = DetailViewController()
        detailViewController.configurePokeID(id)
        
        self.navigationController?.pushViewController(detailViewController, animated: true)
    }
    
}
