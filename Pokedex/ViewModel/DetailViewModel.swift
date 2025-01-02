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
    
    private weak var detailViewController: DetailViewController?
    
    init(detailViewController: DetailViewController) {
        self.detailViewController = detailViewController
        //pokeID 가 설정되는 것에 대해 관측하면 좋을 것 같다.
        self.fetchPokeImage()
        self.fetchPokeDetails()
    }
    
    
    private func fetchPokeDetails() {
        guard let pokeID = detailViewController?.pokeID else { return }
        
        pokeAPIManager
            .fetchPokemonDetails(of: pokeID)?
            .subscribe(
                onSuccess: { [weak self] pokeDetails in
                    guard let pokeDeatailFormatter = PokeDetailsFormatter(pokeDetails) else { return }
                    self?.detailViewController?
                        .updateLabel(by: pokeDeatailFormatter)
                },
                onFailure: { [weak self] error in
                    switch error {
                    case NetworkManagerError.decodeFailed:
                        self?.detailViewController?
                            .presentErroAlert(error, completion: nil)
                    default:
                        self?.detailViewController?
                            .presentErroAlert(error, completion: self?.fetchPokeDetails)
                    }
                }
            ).disposed(by: disposeBag)
    }
    
    
    private func fetchPokeImage() {
        guard let pokeID = detailViewController?.pokeID else { return }
        
        pokeAPIManager
            .fetchPokemonImage(of: pokeID)?
            .subscribe(
                onSuccess: { [weak self] data in
                    guard let image = UIImage(data: data) else { return }
                    self?.detailViewController?
                        .updateImage(by: image)
                },
                onFailure: { [weak self] error in
                    switch error {
                    case NetworkManagerError.decodeFailed:
                        self?.detailViewController?
                            .presentErroAlert(error, completion: nil)
                    default:
                        self?.detailViewController?
                            .presentErroAlert(error, completion: self?.fetchPokeImage)
                    }
                }
            ).disposed(by: disposeBag)
    }
}
