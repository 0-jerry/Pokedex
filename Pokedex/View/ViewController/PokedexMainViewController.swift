//
//  ViewController.swift
//  Pokedex
//
//  Created by t2023-m0072 on 12/23/24.
//

import UIKit
import SnapKit
import RxSwift

final class PokedexMainViewController: UIViewController {
    
    private let mainViewModel: MainViewModel = PokemonAPIManager.shared
    private var poketmonList: PokemonList?
    private let disposeBag = DisposeBag()
    private var mainView: MainView?
    
    override func loadView() {
        super.loadView()
        
        let mainView = MainView(frame: view.frame)
        self.mainView = mainView
        view = mainView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainView?.collectionView.dataSource = self
        mainView?.collectionView.delegate = self
        updatePokemons()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.navigationController?.navigationBar.isHidden = false
    }
    
    private func updatePokemons() {
        guard let single = mainViewModel.fetchPokemonList(limit: 20, offset: 0) else { return }
        
        single.subscribe(onSuccess: { [weak self] pokemonList in
            guard let self,
                  let mainView = self.mainView else { return }
            
            self.poketmonList = pokemonList
            
            DispatchQueue.main.async {
                mainView.reload()
            }
        }).disposed(by: disposeBag)
    }
    
}

extension PokedexMainViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        poketmonList?.pokemons.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let defaultCell = collectionView.dequeueReusableCell(withReuseIdentifier: PokeCollectionViewCell.id, for: indexPath)
        
        guard let pokeCollectionViewCell = defaultCell as? PokeCollectionViewCell else {
            return defaultCell
        }
        
        guard let pokemon = poketmonList?.pokemons[indexPath.item],
              let id = pokemon.id else {
            return defaultCell
        }
        
        pokeCollectionViewCell.configurePokeID(id)
        
        return defaultCell
    }
    
}


extension PokedexMainViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let pokemon = poketmonList?.pokemons[indexPath.item],
              let id = pokemon.id else { return }
        
        let detailViewController = DetailViewController()
        detailViewController.configurePokeID(id)
        
        self.navigationController?.pushViewController(detailViewController, animated: true)
    }
}


#Preview {
    PokedexMainViewController()
}
