//
//  MainView.swift
//  Pokedex
//
//  Created by t2023-m0072 on 12/23/24.
//

import UIKit
import SnapKit

final class MainView: UIView {
    
    private let pokeBallImageView: UIImageView = {
        let imageView = UIImageView()
        
        let pokeBallImage = UIImage(resource: .pokeBall)
        imageView.image = pokeBallImage
        imageView.backgroundColor = .clear
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    
    let collectionView: UICollectionView = {
        
        let itemsForLow: CGFloat = 3
        let itemSpacing: CGFloat = 10
        let width = (UIScreen.main.bounds.width - (itemsForLow - 1) * itemSpacing) / itemsForLow
        
        let flowlayout = UICollectionViewFlowLayout()
        flowlayout.itemSize = .init(width: width, height: width)
        flowlayout.minimumLineSpacing = itemSpacing
        flowlayout.minimumInteritemSpacing = itemSpacing
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowlayout)
        collectionView.backgroundColor = .clear
        
        return collectionView
    }()
    

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUI()
        configureCollectionView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        backgroundColor = .mainRed

        [
            pokeBallImageView,
            collectionView
        ].forEach { addSubview($0) }
        
        pokeBallImageView.snp.makeConstraints { imageView in
            imageView.centerX.equalToSuperview()
            imageView.top.equalTo(safeAreaLayoutGuide).inset(20)
            imageView.width.height.equalTo(120)
        }
        
        collectionView.snp.makeConstraints { collectionView in
            collectionView.leading.trailing.equalToSuperview()
            collectionView.top.equalTo(pokeBallImageView.snp.bottom).offset(20)
            collectionView.bottom.equalTo(safeAreaLayoutGuide).inset(30)
        }
        
        collectionView.backgroundColor = UIColor.darkRed
    }
    
    private func configureCollectionView() {
        collectionView.register(PokeCollectionViewCell.self, forCellWithReuseIdentifier: PokeCollectionViewCell.id)
    }
    
    func reload() {
        self.collectionView.reloadData()
    }
}
