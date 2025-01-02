//
//  PokeCollectionViewCellModel.swift
//  Pokedex
//
//  Created by t2023-m0072 on 1/2/25.
//

import UIKit
import RxSwift

final class PokeCollectionViewCellModel {
    
    private let disposeBag = DisposeBag()
    
    private let pokeAPIManager = PokemonAPIManager.shared
    
    private weak var pokeCollectionViewCell: PokeCollectionViewCell?
    
    init(pokeCollectionViewCell: PokeCollectionViewCell) {
        self.pokeCollectionViewCell = pokeCollectionViewCell
        fetchImage()
    }
    
    private func fetchImage() {
        guard let pokeCollectionViewCell = pokeCollectionViewCell,
              let pokeID = pokeCollectionViewCell.pokeID else { return }
        
        pokeAPIManager.fetchPokemonImage(of: pokeID)?
            .compactMap { UIImage(data: $0) }
            .subscribe(onSuccess: { image in
                pokeCollectionViewCell.updateImage(by: image)
            }).disposed(by: disposeBag)
    }
}
