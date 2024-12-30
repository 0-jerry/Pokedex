//
//  ViewController.swift
//  Pokedex
//
//  Created by t2023-m0072 on 12/30/24.
//

import UIKit

final class DetailViewController: UIViewController {
    
    private let detailView = DetailView()

    override func loadView() {
        super.loadView()
        
        view = self.detailView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.isHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.navigationController?.navigationBar.isHidden = true
    }

    func configurePokeID(_ pokeID: Int) {
        self.detailView.configurePokeID(pokeID)
    }
}
