//
//  NetworkManager.swift
//  Pokedex
//
//  Created by t2023-m0072 on 12/23/24.
//

import UIKit

import RxSwift

/// Network 통신을 담당하는 싱글톤 매니저
///
/// **fetch<T: Decodable>(url: URL)** : 데이터를 요청하고 Decodable 이벤트를 생성하는 Single 을 반환합니다.
final class NetworkManager {
    
    static let shared = NetworkManager()
    
    private let cache: NetworkCache
    private let responseHandler = NetworkResponseHandler()
    
    private init() {
        self.cache = NetworkCache.shared
    }
    
}

extension NetworkManager {
    
    /// 지정된 URL 로 GET 요청을 수행하여 Decodable 타입의 데이터를 반환
    ///
    /// - Parameter url: 요청 URL
    /// - Returns: Decodable 타입으로 디코딩된 응답 데이터를 담은 Single<T> 객체
    func fetch<T: Decodable>(url: URL) -> Single<T> {
        if let single: Single<T> = cacheSingleValue(url) {
            return single
        }
        
        // 컴플리션을 통해 응답에 대한 observer를 실행시키는 Single 객체
        let single = Single<T>.create(subscribe: { observer in
            let request = URLRequest(url: url)
            URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
                
                // 앱이 꺼져 NetworkManager 가 메모리에서 해제된 경우
                guard let self else {
                    observer(.failure(NetworkManagerError.unknown))
                    return
                }
                
                do {
                    let data = try self.responseHandler.handle(data, response, error)
                    let value: T = try self.value(from: data)
                    
                    observer(.success(value))
                    self.cache.setData(data, forKey: url)
                    
                } catch let error {
                    observer(.failure(error))
                }
            }.resume()
            
            return Disposables.create()
        })
        return single
    }
    
    /// 지정된 URL 로 GET 요청을 수행하여 Data 타입의 데이터를 반환
    ///
    /// - Parameter url: 요청 URL
    /// - Returns: Data 타입으로 응답 데이터를 담은 Single<Data> 객체
    func fetchImage(url: URL) -> Single<UIImage> {
        if let single = cacheSingleImage(url) {
            return single
        }
        
        // 컴플리션을 통해 응답에 대한 observer를 실행시키는 Single 객체
        let single = Single<UIImage>.create(subscribe: { observer in
            let request = URLRequest(url: url)
            URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
                guard let self else {
                    observer(.failure(NetworkManagerError.unknown))
                    return }
                
                do {
                    let data = try self.responseHandler.handle(data, response, error)
                    let image = try self.image(from: data)
                    
                    observer(.success(image))
                    self.cache.setData(data, forKey: url)
                    
                } catch let error {
                    observer(.failure(error))
                }
                
            }.resume()
            
            return Disposables.create()
        })
        return single
    }
    
}

extension NetworkManager {
    private func value<T: Decodable>(from data: Data) throws -> T {
        guard let value = try? JSONDecoder().decode(T.self, from: data) else {
            throw NetworkManagerError.invalidData
        }
        
        return value
    }
    
    private func image(from data: Data) throws -> UIImage {
        guard let image = UIImage(data: data) else {
            throw NetworkManagerError.invalidData
        }
        
        return image
    }
        
    private func cacheSingleValue<T: Decodable>(_ url: URL) -> Single<T>? {
        guard let data = cache.data(forKey: url),
              let value = try? JSONDecoder().decode(T.self, from: data) else { return nil }
        let single = SingleTranslator.single(value)
        
        return single
        
    }
    
    private func cacheSingleImage(_ url: URL) -> Single<UIImage>? {
        guard let data = cache.data(forKey: url),
              let image = UIImage(data: data) else { return nil }
        let single = SingleTranslator.single(image)
        
        return single
    }
    
}
