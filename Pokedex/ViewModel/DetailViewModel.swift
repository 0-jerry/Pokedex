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
    
    private let pokeAPIManager = PokemonAPIManager.shared
    
    private let pokeDetailsSubject = BehaviorSubject<PokeDetailsFormatter>(value: .default)
    
    private let pokeImageSubject = BehaviorSubject<UIImage>(value: .pokeBall)
    
    private let pokeIDSubject: BehaviorSubject<Int>
    
    private var pokeID: Observable<Int> {
        return pokeIDSubject.asObservable()
    }
    
    var pokeDetails: Observable<PokeDetailsFormatter> {
        return pokeDetailsSubject.asObservable()
    }
    
    var pokeImage: Observable<UIImage> {
        return pokeImageSubject.asObservable()
    }
    
    init(pokeID: Int) {
        self.pokeIDSubject = BehaviorSubject<Int>(value: pokeID)
        bind()
    }
    
    // 개선 방향 찾아야함 -> ViewDidload 시점에 실행되게 하는 방법?
    private func bind() {
        pokeID.subscribe(onNext: { [weak self] pokeID in
            self?.fetchPokeDetails(pokeID)
            self?.fetchPokeImage(pokeID)
        }).disposed(by: disposeBag)
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
