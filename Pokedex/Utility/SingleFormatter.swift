//
//  SingleFormatter.swift
//  Pokedex
//
//  Created by t2023-m0072 on 1/5/25.
//

import Foundation

import RxSwift

struct SingleFormatter {
    
    static func single<T>(_ value: T) -> Single<T> {
        let single = Single<T>.create { observer in
            observer(.success(value))
            return Disposables.create()
        }
        
        return single
    }
}
