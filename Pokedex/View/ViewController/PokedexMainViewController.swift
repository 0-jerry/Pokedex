//
//  ViewController.swift
//  Pokedex
//
//  Created by t2023-m0072 on 12/23/24.
//

import UIKit
import SnapKit
import RxSwift

class PokedexMainViewController: UIViewController {
    
    private let pokemonAPIManager = PokemonAPIManager.shared
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
        updatePokemons()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }
    
    private func updatePokemons() {
        guard let single = pokemonAPIManager.fetchPokemonList(limit: 200, offset: 0) else { return }
        
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
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PokeCollectionViewCell.id, for: indexPath) as? PokeCollectionViewCell else { return PokeCollectionViewCell() }
        guard var poketmon = poketmonList?.pokemons[indexPath.item],
              let id = poketmon.id else { return PokeCollectionViewCell() }
        
        cell.configurePokeID(id)
        
        return cell
    }
    
}


#Preview {
    PokedexMainViewController()
}
