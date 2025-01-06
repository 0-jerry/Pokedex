//
//  NetworkManagerError.swift
//  Pokedex
//
//  Created by t2023-m0072 on 1/5/25.
//

import Foundation

enum NetworkManagerError: Error, CustomStringConvertible {
    
    var description: String {
        switch self {
        case .invalidResponse(statusCode: let statusCode):
            return "HTTP StatusCode Error - \(statusCode ?? 000)"
        case .decodeFailed:
            return "Decode Failed"
        case .invalidData:
            return "Invalid Data"
        case .unknown:
            return "Unknown Error"

        }
    }
    
    case invalidResponse(statusCode: Int?)
    case decodeFailed
    case invalidData
    case unknown
}
