//
//  PokeCollectionViewCell.swift
//  Pokedex
//
//  Created by t2023-m0072 on 12/23/24.
//

import UIKit

import RxSwift
import SnapKit

final class PokeCollectionViewCell: UICollectionViewCell {
    
    static let id = "PokeCollectionViewCell"
    
    private var disposeBag = DisposeBag()
    
    private let pokeIDSubject = BehaviorSubject<Int?>(value: nil)
    
    private let pokeCollectionViewCellViewModel = PokeCollectionViewCellViewModel()
    
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
        configureUI()
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func reset() {
        pokeImageView.image = nil
    }
    
    private func configureUI() {
        
        backgroundColor = .cellBackground
        
        addSubview(pokeImageView)
        
        pokeImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        self.layer.cornerRadius = 10
        self.clipsToBounds = true
    }
    
    func configurePokeID(_ pokeID: Int) {
        self.pokeIDSubject.onNext(pokeID)
    }
}

extension PokeCollectionViewCell {
    
    private func bind() {
        let pokeID = pokeIDSubject.asObservable()
        let input = PokeCollectionViewCellViewModel.Input(pokeID: pokeID)
        let output = pokeCollectionViewCellViewModel.transForm(input)
        
        output.pokeImage.subscribe(onNext: { [weak self] image in
            guard let image else { return }
            DispatchQueue.main.async {
                self?.pokeImageView.image = image
            }
        }).disposed(by: disposeBag)
    }
    
}
