//
//  ErrorAlertPresentable.swift
//  Pokedex
//
//  Created by t2023-m0072 on 1/2/25.
//

import UIKit

protocol ErrorAlertPresentable: UIViewController {}

extension ErrorAlertPresentable {
    
    func presentErroAlert(_ error: Error, completion: (() -> Void)?) {
        
        let errorMassage = String(describing: error)
        
        let alertController = UIAlertController(title: "Error",
                                                message: errorMassage,
                                                preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "retry", style: .default)
        
        alertController.addAction(cancelAction)
        DispatchQueue.main.async {
            self.navigationController?.present(alertController, animated: true)
        }
        completion?()
    }
    
}
