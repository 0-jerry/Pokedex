//
//  PokeView.swift
//  Pokedex
//
//  Created by t2023-m0072 on 12/25/24.
//

import UIKit

protocol PokeView: UIView {
    
    var pokeID: Int? { get set }
    
    func updatePokeUI()

}

extension PokeView {
    
    func configurePokeID(_ pokeID: Int) {
        self.pokeID = pokeID
        updatePokeUI()
    }

}
