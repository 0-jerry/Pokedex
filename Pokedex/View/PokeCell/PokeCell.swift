//
//  PokeCollectionViewCell.swift
//  Pokedex
//
//  Created by t2023-m0072 on 12/23/24.
//

import UIKit

import RxSwift
import SnapKit

final class PokeCell: UICollectionViewCell {
    
    static let id = "PokeCell"
    
    private var disposeBag = DisposeBag()
    
    private let pokeIDSubject = BehaviorSubject<PokeID?>(value: nil)
    
    private let viewModel = PokeCellViewModel()
    
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
    
    func configurePokeID(_ pokeID: PokeID) {
        self.pokeIDSubject.onNext(pokeID)
    }
}

extension PokeCell {
    
    private func bind() {
        let pokeID = pokeIDSubject.asObservable()
        let input = PokeCellViewModel.Input(pokeID: pokeID)
        let output = viewModel.transForm(input)
        
        output.pokeImage
            .observe(on: MainScheduler.instance)
            .bind(to: pokeImageView.rx.image)
            .disposed(by: disposeBag)
    }
    
}
