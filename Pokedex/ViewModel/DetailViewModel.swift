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
        
    private let pokeDetailsPublisher = PublishSubject<PokeDetailsFormatter>()
    
    private let pokeImagePublisher = PublishSubject<UIImage>()
    
    private let pokeID: Int
    
    var pokeDetails: Observable<PokeDetailsFormatter> {
        return pokeDetailsPublisher.asObservable()
    }
    
    var pokeImage: Observable<UIImage> {
        return pokeImagePublisher.asObservable()
    }
    
    init(pokeID: Int) {
        self.pokeID = pokeID
    }
    
    // 개선 방향 찾아야함 -> ViewDidload 시점에 실행되게 하는 방법?
    func publish() {
        fetchPokeImage(pokeID)
        fetchPokeDetails(pokeID)
    }
    
    private func fetchPokeDetails(_ pokeID: Int) {
        pokeAPIManager
            .fetchPokemonDetails(of: pokeID)?
            .compactMap { PokeDetailsFormatter($0) }
            .subscribe(
                onSuccess: { [weak self] pokeDetailsFormatter in
                    self?.pokeDetailsPublisher.onNext(pokeDetailsFormatter)
                }
            ).disposed(by: disposeBag)
    }
    
    private func fetchPokeImage(_ pokeID: Int) {
        pokeAPIManager
            .fetchPokemonImage(of: pokeID)?
            .compactMap { UIImage(data: $0) }
            .subscribe(
                onSuccess: { [weak self] image in
                    self?.pokeImagePublisher.onNext(image)
                }).disposed(by: disposeBag)
    }
    
}
