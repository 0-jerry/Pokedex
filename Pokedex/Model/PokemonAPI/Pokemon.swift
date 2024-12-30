//
//  Pokemon.swift
//  Pokedex
//
//  Created by t2023-m0072 on 12/30/24.
//

import Foundation

// 포켓몬 간단한 데이터 형식
struct Pokemon: Decodable, CustomStringConvertible {
    
    var description: String {
        guard let name,
              let url else { return "pokemon"}
        return """
        name: \(name)
        url: \(url)
        """
    }
    
    let name: String?
    let url: String?
    
    // FIXME: - 적합한 형태는 아닌 것 같다.
    lazy var id: Int? = {
        guard let url else { return 1 }
        var components = url.components(separatedBy: "/")
        let number = components[components.count - 2]
        guard let id = Int(number) else { return 1 }
        return id
    }()
    
    private(set) lazy var detailsURL: URL? = URL(from: url)
}
