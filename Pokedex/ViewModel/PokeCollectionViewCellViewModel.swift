//
//  PokeCollectionViewCellModel.swift
//  Pokedex
//
//  Created by t2023-m0072 on 1/2/25.
//

import UIKit

import RxSwift

final class PokeCollectionViewCellViewModel {
    
    private let disposeBag = DisposeBag()
    
    private let pokeID: Int
    
    private let pokeAPIManager = PokemonAPIManager.shared
    
    private let pokeImagePublisher = BehaviorSubject<UIImage>(value: .pokeBall)
    
    var pokeImage: Observable<UIImage> {
        pokeImagePublisher.asObservable()
    }
        
    init(pokeID: Int) {
        self.pokeID = pokeID
        fetchImage()
    }
    
    private func fetchImage() {
        pokeAPIManager.fetchPokemonImage(of: pokeID)?
            .subscribe(onSuccess: { [weak self] image in
                self?.pokeImagePublisher.onNext(image)
            }).disposed(by: disposeBag)
    }
}
