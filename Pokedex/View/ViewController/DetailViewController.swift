//
//  ViewController.swift
//  Pokedex
//
//  Created by t2023-m0072 on 12/30/24.
//

import UIKit

import RxSwift
import RxCocoa
import SnapKit

final class DetailViewController: UIViewController, ErrorAlertPresentable {
    
    private static let nameFont = UIFont.systemFont(ofSize: 28, weight: .bold)
    private static let littleFont = UIFont.systemFont(ofSize: 20, weight: .semibold)
    
    private let disposeBag = DisposeBag()
    private let detailsViewModel: DetailViewModel
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        
        stackView.spacing = 5
        stackView.distribution = .fill
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.backgroundColor = .darkRed
        stackView.layer.cornerRadius = 15
        stackView.clipsToBounds = true
        
        return stackView
    }()
    
    private let pokeImageView: UIImageView = {
        let imageView = UIImageView()
        
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .clear
        
        return imageView
    }()
    
    private let nameLabel: UILabel = detailsLabel(nameFont)
    private let typeLabel: UILabel = detailsLabel(littleFont)
    private let weightLabel: UILabel = detailsLabel(littleFont)
    private let heightLabel: UILabel = detailsLabel(littleFont)
    private let emptyView: UIView = UIView()
    
    init(detailsViewModel: DetailViewModel) {
        self.detailsViewModel = detailsViewModel
        super.init(nibName: nil, bundle: nil)
        
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.isHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.navigationController?.navigationBar.isHidden = true
    }
    
    
    private func configureUI() {
        
        view.backgroundColor = .mainRed
        
        view.addSubview(stackView)
        
        [
            pokeImageView,
            nameLabel,
            typeLabel,
            weightLabel,
            heightLabel,
            emptyView
        ].forEach { stackView.addArrangedSubview($0) }
        
        stackView.snp.makeConstraints { stackView in
            stackView.top.equalTo(view.safeAreaLayoutGuide).inset(60)
            stackView.leading.trailing.equalToSuperview().inset(20)
        }
        
        pokeImageView.snp.makeConstraints { imageView in
            imageView.width.height.equalTo(300)
        }
        
        nameLabel.snp.makeConstraints { label in
            label.height.equalTo(50)
            label.leading.trailing.equalToSuperview().inset(30)
        }
        
        [
            typeLabel,
            weightLabel,
            heightLabel,
            emptyView
        ].forEach {
            $0.snp.makeConstraints { view in
                view.height.equalTo(30)
                view.leading.trailing.equalToSuperview().inset(30)
            }
        }
        
    }
    
    private static func detailsLabel(_ font: UIFont) -> UILabel {
        let label = UILabel()
        
        label.font = font
        label.textColor = .white
        label.numberOfLines = 1
        label.backgroundColor = .clear
        label.textAlignment = .center
        
        return label
    }
    
}

// MARK: - bind

extension DetailViewController {
    
    private func bind() {
        [
            detailsViewModel.pokeDetails
                .map { $0.name }
                .bind(to: nameLabel.rx.text),
            detailsViewModel.pokeDetails
                .map { $0.type }
                .bind(to: typeLabel.rx.text),
            detailsViewModel.pokeDetails
                .map { $0.weight }
                .bind(to: weightLabel.rx.text),
            detailsViewModel.pokeDetails
                .map { $0.height }
                .bind(to: heightLabel.rx.text),
            detailsViewModel.pokeImage
                .subscribe { [weak self] image in
                    self?.updateImage(by: image) }
        ].forEach { $0.disposed(by: disposeBag) }

    }
    
}

// MARK: - UI Update

extension DetailViewController {
    
    private func updateImage(by image: UIImage) {
            
        DispatchQueue.main.async {
            self.pokeImageView.image = image
        }
    }
    
}
