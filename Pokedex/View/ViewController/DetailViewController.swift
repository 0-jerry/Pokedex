//
//  ViewController.swift
//  Pokedex
//
//  Created by t2023-m0072 on 12/30/24.
//

import UIKit

import RxSwift

final class DetailViewController: UIViewController {
    
    private let detailView = DetailView()
    private let detailViewModel = PokemonAPIManager.shared
    private let disposeBag = DisposeBag()
    var pokeID: Int?
    
    override func loadView() {
        super.loadView()
        
        view = self.detailView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.isHidden = false
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.navigationController?.navigationBar.isHidden = true
    }
    
    func configurePokeID(_ pokeID: Int) {
        self.pokeID = pokeID
        binding()
    }
    
    func binding() {
        guard let pokeID else { return }
        
        detailViewModel
            .fetchPokemonDetails(of: pokeID)?
            .subscribe(
                onSuccess: { [weak self] pokemonDetails in
                    self?.detailView.updateLabel(by: pokemonDetails)
                }
            ).disposed(by: disposeBag)
        
        detailViewModel
            .fetchPokemonImage(of: pokeID)?
            .subscribe(
                onSuccess: { [weak self] data in
                    self?.detailView.updateImage(by: data)
                }
            ).disposed(by: disposeBag)
    }
}
