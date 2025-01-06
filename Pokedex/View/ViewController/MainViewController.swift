//
//  ViewController.swift
//  Pokedex
//
//  Created by t2023-m0072 on 12/23/24.
//

import UIKit

import RxSwift
import SnapKit

final class MainViewController: UIViewController, ErrorAlertPresentable {
    
    private let mainViewModel: MainViewModel
    
    private let disposeBag = DisposeBag()
    
    private var pokemons = [Pokemon]()
    
    private var scrollEnabled: Bool = true
    
    private let scrollEndPoint = PublishSubject<Void>()
    
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
    
    init() {
        self.mainViewModel = MainViewModel()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        configureCollectionView()
        bind()
    }
    
    private func configureUI() {
        view.backgroundColor = .mainRed
        
        [
            pokeBallImageView,
            collectionView
        ].forEach { view.addSubview($0) }
        
        pokeBallImageView.snp.makeConstraints { imageView in
            imageView.centerX.equalToSuperview()
            imageView.top.equalTo(view.safeAreaLayoutGuide)
            imageView.width.height.equalTo(80)
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
    
}

// MARK: - Rx

extension MainViewController {
    
    private func bind() {
        let viewDidLoad = Single<Void>.create { observer in
            observer(.success(()))
            return Disposables.create()
        }
        let scrollEndPoint = scrollEndPoint.asObserver()
        
        let input = MainViewModel.Input(viewDidLoad: viewDidLoad,
                                        scrollEndpoint: scrollEndPoint)
        
        let output = mainViewModel.transform(input)
        
        output.pokemons
            .subscribe(onNext: { [weak self] pokemons in
            self?.configurePokemons(pokemons)
            }).disposed(by: disposeBag)
    }
    
    private func configurePokemons(_ pokemons: [Pokemon]) {
        self.pokemons += pokemons
        
        DispatchQueue.main.async {
            self.collectionView.reloadData()
            
            DispatchQueue.global().async {
                self.scrollEnabled = true
            }
            
        }
    }
    
}


extension MainViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pokemons.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let defaultCell = collectionView.dequeueReusableCell(withReuseIdentifier: PokeCollectionViewCell.id, for: indexPath)
        
        guard let pokeCollectionViewCell = defaultCell as? PokeCollectionViewCell,
              let pokeID = pokemons[indexPath.item].id else { return defaultCell }

        pokeCollectionViewCell.configurePokeID(pokeID)
        
        return pokeCollectionViewCell
    }
    
}


extension MainViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let pokeID = pokemons[indexPath.item].id else { return }
        
        let detailViewController = DetailViewController()
        detailViewController.configurePokeID(pokeID)
        
        self.navigationController?.pushViewController(detailViewController, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard scrollEnabled else { return }
        
        if pokemons.count - 3 == indexPath.item {
            scrollEnabled = false
            scrollEndPoint.onNext(())
        }
    }
    
}
