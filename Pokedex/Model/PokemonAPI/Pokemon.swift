//
//  Pokemon.swift
//  Pokedex
//
//  Created by t2023-m0072 on 12/30/24.
//

import Foundation

// 포켓몬 간단한 데이터 형식
struct Pokemon: Decodable {
    
    let name: String?
    let url: String?
    
    // FIXME: - 적합한 형태는 아닌 것 같다.
    var id: Int? {
        guard let url else { return 1 }
        let components = url.components(separatedBy: "/")
        let number = components[components.count - 2]
        guard let id = Int(number) else { return 1 }
        return id
    }
    
    var detailsURL: URL? { URL(from: url) }
    
}
