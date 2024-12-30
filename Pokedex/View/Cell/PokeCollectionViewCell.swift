//
//  PokeCollectionViewCell.swift
//  Pokedex
//
//  Created by t2023-m0072 on 12/23/24.
//

import UIKit

import SnapKit
import RxSwift
import Kingfisher

final class PokeCollectionViewCell: UICollectionViewCell, PokeView {
    
    static let id = "PokeCollectionViewCell"
    
    var pokeID: Int?
    
    private let disposeBag = DisposeBag()
    private let pokemonAPIManager = PokemonAPIManager.shared
    
    private let pokeImageView: UIImageView = {
        let imageView = UIImageView()
        
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .clear
        
        return imageView
    }()
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        reset()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .cellBackground
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func reset() {
        pokeImageView.image = nil
        pokeID = nil
    }
    
    private func configureUI() {
        addSubview(pokeImageView)
        
        pokeImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        self.layer.cornerRadius = 10
        self.clipsToBounds = true
    }
    
    func updatePokeUI() {
        guard let pokeID,
              let single = pokemonAPIManager.fetchPokemonImage(of: pokeID) else { return }
        
        single.subscribe(onSuccess: { [weak self] data in
            guard let image = UIImage(data: data) else { return }
            
            DispatchQueue.main.async {
                self?.pokeImageView.image = image
            }
        }).disposed(by: disposeBag)
        
    }
    
}
