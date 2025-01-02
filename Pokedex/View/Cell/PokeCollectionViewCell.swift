//
//  PokeCollectionViewCell.swift
//  Pokedex
//
//  Created by t2023-m0072 on 12/23/24.
//

import UIKit

import SnapKit

final class PokeCollectionViewCell: UICollectionViewCell {
        
    static let id = "PokeCollectionViewCell"
    
    private var pokeCollectionViewCellModel: PokeCollectionViewCellModel?
    
    private(set) var pokeID: Int?
    
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
    }
    
    
    func configurePokeID(_ pokeID: Int) {
        self.pokeID = pokeID
        pokeCollectionViewCellModel = PokeCollectionViewCellModel(pokeCollectionViewCell: self)
    }
    
    private func configureUI() {
        addSubview(pokeImageView)
        
        pokeImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        self.layer.cornerRadius = 10
        self.clipsToBounds = true
    }
        
}

extension PokeCollectionViewCell {
    
    func updateImage(by image: UIImage) {
        DispatchQueue.main.async { [weak self] in
            self?.pokeImageView.image = image
        }
    }
}
