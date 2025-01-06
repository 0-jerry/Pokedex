//
//  NetworkResponseHandler.swift
//  Pokedex
//
//  Created by t2023-m0072 on 1/6/25.
//

import Foundation

struct NetworkResponseHandler {
    
    func handle(_ data: Data?, _ response: URLResponse?, _ error: (any Error)?) throws -> Data {
        try checkError(error)
        try checkResponse(response)
        let data = try checkData(data)
        
        return data
    }
    
    private func checkError(_ error: (any Error)?) throws {
        if let error {
            throw error
        }
    }
    
    private func checkResponse(_ response: URLResponse?) throws {
        // HTTP 가 아닌 응답 경우
        guard let response = response as? HTTPURLResponse else {
            throw NetworkManagerError.invalidResponse(statusCode: nil)
        }
        
        // 요청이 실패한 경우
        let statusCode = response.statusCode
        guard (200..<300).contains(statusCode) else {
            throw NetworkManagerError.invalidResponse(statusCode: statusCode)
        }
    }
    
    private func checkData(_ data: Data?) throws -> Data {
        guard let data else {
            throw NetworkManagerError.invalidData
        }
        
        return data
    }
    
}
