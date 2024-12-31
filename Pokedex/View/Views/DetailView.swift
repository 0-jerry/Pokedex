//
//  DetailView.swift
//  Pokedex
//
//  Created by t2023-m0072 on 12/30/24.
//

import UIKit

import SnapKit

final class DetailView: UIView {
    
    var onPresentAlert: ((UIAlertController) -> Void)?
    
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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - UI

extension DetailView {
    
    private func configureUI() {
        
        backgroundColor = .mainRed
        
        addSubview(stackView)
        
        [
            pokeImageView,
            nameLabel,
            typeLabel,
            weightLabel,
            heightLabel,
            emptyView
        ].forEach { stackView.addArrangedSubview($0) }
        
        stackView.snp.makeConstraints { stackView in
            stackView.top.equalTo(safeAreaLayoutGuide).inset(60)
            stackView.leading.trailing.equalToSuperview().inset(20)
        }
        
        pokeImageView.snp.makeConstraints { imageView in
            imageView.top.equalToSuperview().inset(30)
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

}

// MARK: - PokeView

extension DetailView {
    
    func updateImage(by data: Data) {
        guard let image = UIImage(data: data) else { return }
        
        DispatchQueue.main.async {
            self.pokeImageView.image = image
        }
    }
    
    func updateLabel(by pokemonDetails: PokemonDetails) {
        guard let pokeDetailsFormatter = PokeDetailsFormatter(pokemonDetails) else { return }
        
        DispatchQueue.main.async {
            self.nameLabel.text = pokeDetailsFormatter.name
            self.typeLabel.text = pokeDetailsFormatter.type
            self.heightLabel.text = pokeDetailsFormatter.height
            self.weightLabel.text = pokeDetailsFormatter.weight
        }
    }
    
}
