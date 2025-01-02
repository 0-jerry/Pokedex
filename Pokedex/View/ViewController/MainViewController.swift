//
//  ViewController.swift
//  Pokedex
//
//  Created by t2023-m0072 on 12/23/24.
//

import UIKit

import SnapKit

final class MainViewController: UIViewController, ErrorAlertPresentable {
    
    private var mainViewModel: MainViewModel?
    
    // 포켓몬 볼 이미지 뷰
    private let pokeBallImageView: UIImageView = {
        let imageView = UIImageView()
        
        let pokeBallImage = UIImage(resource: .pokeBall)
        imageView.image = pokeBallImage
        imageView.backgroundColor = .clear
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    
    // 컬렌션 뷰
    private let collectionView: UICollectionView = {
        
        let itemsForLow: CGFloat = 3
        let itemSpacing: CGFloat = 10
        let width = (UIScreen.main.bounds.width - (itemsForLow - 1) * itemSpacing) / itemsForLow
        
        let flowlayout = UICollectionViewFlowLayout()
        flowlayout.itemSize = .init(width: width, height: width)
        flowlayout.minimumLineSpacing = itemSpacing
        flowlayout.minimumInteritemSpacing = itemSpacing
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowlayout)
        collectionView.backgroundColor = .darkRed
        collectionView.showsVerticalScrollIndicator = false
        
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.mainViewModel = MainViewModel(mainViewController: self)
        configureUI()
        configureCollectionView()
    }
    
    private func configureUI() {
        view.backgroundColor = .mainRed
        
        [
            pokeBallImageView,
            collectionView
        ].forEach { view.addSubview($0) }
        
        pokeBallImageView.snp.makeConstraints { imageView in
            imageView.centerX.equalToSuperview()
            imageView.top.equalTo(view.safeAreaLayoutGuide).inset(20)
            imageView.width.height.equalTo(120)
        }
        
        collectionView.snp.makeConstraints { collectionView in
            collectionView.leading.trailing.equalToSuperview()
            collectionView.top.equalTo(pokeBallImageView.snp.bottom).offset(20)
            collectionView.bottom.equalTo(view.safeAreaLayoutGuide).inset(30)
        }
        
    }
    
    
    private func configureCollectionView() {
        collectionView.register(PokeCollectionViewCell.self, forCellWithReuseIdentifier: PokeCollectionViewCell.id)
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    func viewReload() {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    func presentErroAlert(_ error: Error, completion: (() -> Void)?) {
        let alertController = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "retry", style: .default)
        alertController.addAction(cancelAction)
        self.navigationController?.present(alertController, animated: true, completion: completion)
    }
}


extension MainViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let mainViewModel else { return 0 }
        return mainViewModel.pokemons.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let defaultCell = collectionView.dequeueReusableCell(withReuseIdentifier: PokeCollectionViewCell.id, for: indexPath)
        
        guard let pokeCollectionViewCell = defaultCell as? PokeCollectionViewCell,
              let pokeID = mainViewModel?.pokemons[indexPath.item].id else { return defaultCell }
        
        //pokeCollectionViewCell - configure
        pokeCollectionViewCell.configurePokeID(pokeID)
        
        return pokeCollectionViewCell
    }
    
}


extension MainViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let pokeID = mainViewModel?.pokemons[indexPath.item].id else { return }
        
        let detailViewController = DetailViewController()
        detailViewController.configurePokeID(pokeID)
        self.navigationController?.pushViewController(detailViewController, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let mainViewModel else { return }
        if mainViewModel.pokemons.count - 3 == indexPath.item {
            mainViewModel.fetchPokeList()
        }
    }
}
