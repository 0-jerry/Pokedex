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
    
    private var requestDisposeBag = DisposeBag()
        
    private let pokeAPIManager = PokemonAPIManager.shared
    
    private let pokeImagePublisher = BehaviorSubject<UIImage?>(value: nil)
    
    private func fetchImage(_ pokeID: Int) {
        requestDisposeBag = DisposeBag()
        
        pokeAPIManager.fetchPokemonImage(of: pokeID)?
            .subscribe(onSuccess: { [weak self] image in
                self?.pokeImagePublisher.onNext(image)
            }).disposed(by: requestDisposeBag)
    }
}

extension PokeCollectionViewCellViewModel {
    
    struct Input {
        let pokeID: Observable<Int?>
    }
    
    struct Output {
        let pokeImage: Observable<UIImage?>
    }
    
    func transForm(_ input: Input) -> Output {
        
        input.pokeID
            .withUnretained(self)
            .subscribe(onNext: { owner, pokeID in
                guard let pokeID else { return }
                owner.fetchImage(pokeID)
            }).disposed(by: disposeBag)
        
        let pokeImage = pokeImagePublisher.asObservable()
        
        return Output(pokeImage: pokeImage)
    }
    
}
