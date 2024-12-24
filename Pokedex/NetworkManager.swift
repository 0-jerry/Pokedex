//
//  NetworkManager.swift
//  Pokedex
//
//  Created by t2023-m0072 on 12/23/24.
//

import Foundation

//import
import RxSwift

final class NetworkManager {
    
    static let shared = NetworkManager()
    
    private init() {}
    
}

// MARK: - URL 반환 메서드

extension NetworkManager {
    
    // 데이터 요청 메서드
    func fetch<T: Decodable>(url: URL) -> Single<T> {
        let single = Single<T>.create(subscribe: { observer -> Disposable in
            let request = URLRequest(url: url)
            URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
                
                guard let self,
                      validResponse(response),
                      checkError(error) else { return }
                
                guard let data,
                      let decodable = try? JSONDecoder().decode(T.self,from: data) else { return }
                
                observer(.success(decodable))
            }.resume()
            
            return Disposables.create()
        })
        
        return single
    }
    
    // 응답 검증
    private func validResponse(_ response: URLResponse?) -> Bool {
        guard let response = response as? HTTPURLResponse,
              (200..<300).contains(response.statusCode) else { return false }
        
        return true
    }
    
    // 에러 검증
    private func checkError(_ error: (any Error)?) -> Bool {
        guard error == nil else { return false }
        
        return true
    }
    
}

