//
//  DetailViewModel.swift
//  Pokedex
//
//  Created by t2023-m0072 on 1/2/25.
//

import UIKit

import RxSwift

final class DetailViewModel {
    
    private let disposeBag = DisposeBag()
    
    private let pokeAPIManager: PokemonAPIManager
    
    private let pokeDetailsSubject = BehaviorSubject<PokeDetailsFormatter?>(value: nil)
    
    private let pokeImageSubject = BehaviorSubject<UIImage?>(value: nil)
    
    init() {
        self.pokeAPIManager = PokemonAPIManager.shared
    }
    
    private func fetchPokeDetails(_ pokeID: Int) {
        pokeAPIManager
            .fetchPokemonDetails(of: pokeID)?
            .compactMap { PokeDetailsFormatter($0) }
            .subscribe(
                onSuccess: { [weak self] pokeDetailsFormatter in
                    self?.pokeDetailsSubject.onNext(pokeDetailsFormatter)
                }
            ).disposed(by: disposeBag)
    }
    
    private func fetchPokeImage(_ pokeID: Int) {
        pokeAPIManager
            .fetchPokemonImage(of: pokeID)?
            .subscribe(
                onSuccess: { [weak self] image in
                    self?.pokeImageSubject.onNext(image)
                }).disposed(by: disposeBag)
    }
    
}

extension DetailViewModel {
    
    struct Input {
        let pokeID: Observable<Int?>
    }
    
    struct Output {
        let pokeDetailsFormatter: Observable<PokeDetailsFormatter?>
        let pokeImage: Observable<UIImage?>
    }
    
    func transform(_ input: Input) -> Output {
        
        let pokeDetailsFormatter = pokeDetailsSubject.asObservable()
        let pokeImage = pokeImageSubject.asObservable()
        let output = Output(pokeDetailsFormatter: pokeDetailsFormatter,
                            pokeImage: pokeImage)
        
        input.pokeID
            .subscribe(onNext: { [weak self] pokeID in
                guard let pokeID else { return }
                self?.fetchPokeDetails(pokeID)
                self?.fetchPokeImage(pokeID)
            }).disposed(by: disposeBag)
        
        return output
    }
    
}
