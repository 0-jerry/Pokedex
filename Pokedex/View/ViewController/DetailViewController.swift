//
//  ViewController.swift
//  Pokedex
//
//  Created by t2023-m0072 on 12/30/24.
//

import UIKit

import SnapKit

final class DetailViewController: UIViewController, ErrorAlertPresentable {
    
    private(set) var pokeID: Int?
    
    private var detailsViewModel: DetailViewModel?
    
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
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        
        label.font = .systemFont(ofSize: 28, weight: .bold)
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 1
        
        return label
    }()
    
    private let typeLabel: UILabel = littleLabel()
    
    private let weightLabel: UILabel = littleLabel()
    
    private let heightLabel: UILabel = littleLabel()
    
    private let emptyView: UIView = UIView()
    
    
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

    private static func littleLabel() -> UILabel {
        let label = UILabel()
        
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        label.textColor = .white
        label.numberOfLines = 1
        label.backgroundColor = .clear
        label.textAlignment = .center
        
        return label
    }
    
    // PokeID 를 설정
    func configurePokeID(_ pokeID: Int) {
        self.pokeID = pokeID
        self.detailsViewModel = DetailViewModel(detailViewController: self)
    }
    
    func updateImage(by image: UIImage) {
        DispatchQueue.main.async {
            self.pokeImageView.image = image
        }
    }
    
    func updateLabel(by pokeDetailsFormatter: PokeDetailsFormatter) {
        DispatchQueue.main.async {
            self.nameLabel.text = pokeDetailsFormatter.name
            self.typeLabel.text = pokeDetailsFormatter.type
            self.heightLabel.text = pokeDetailsFormatter.height
            self.weightLabel.text = pokeDetailsFormatter.weight
        }
    }

}
