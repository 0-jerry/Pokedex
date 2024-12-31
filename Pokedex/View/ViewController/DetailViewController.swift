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
    
    // PokeID 를 설정
    func configurePokeID(_ pokeID: Int) {
        self.pokeID = pokeID
        binding()
    }
    
    // DetailViewModel 과 DetailView 연결
    private func binding() {
        guard let pokeID else { return }
        // DetailView 의 클로저가 Single<PokemonDetails> 구독
        detailViewModel
            .fetchPokemonDetails(of: pokeID)?
            .subscribe(
                onSuccess: { [weak self] pokemonDetails in
                    self?.detailView.updateLabel(by: pokemonDetails)
                }
            ).disposed(by: disposeBag)
        
        // DetailView 의 클로저가 Single<Data> 구독
        detailViewModel
            .fetchPokemonImage(of: pokeID)?
            .subscribe(
                onSuccess: { [weak self] data in
                    self?.detailView.updateImage(by: data)
                }
            ).disposed(by: disposeBag)
    }
}
