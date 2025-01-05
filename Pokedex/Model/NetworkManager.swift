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
    
    private let imageCache = ImageCache.shared
    
    private init() {}
        
}

extension NetworkManager {
    
    /// 지정된 URL 로 GET 요청을 수행하여 Decodable 타입의 데이터를 반환
    ///
    /// - Parameter url: 요청 URL
    /// - Returns: Decodable 타입으로 디코딩된 응답 데이터를 담은 Single<T> 객체
    func fetch<T: Decodable>(url: URL) -> Single<T> {

        // 컴플리션을 통해 응답에 대한 observer를 실행시키는 Single 객체
        let single = Single<T>.create(subscribe: { observer in
            let request = URLRequest(url: url)
            URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
                
                // 앱이 꺼져 NetworkManager 가 메모리에서 해제된 경우
                guard self != nil else {
                    observer(.failure(NetworkManagerError.unknown))
                    return
                }
                
                // error 를 응답받은 경우
                if let error {
                    observer(.failure(error))
                    return
                }
                
                // HTTP 가 아닌 응답 경우
                guard let response = response as? HTTPURLResponse else {
                    observer(.failure(NetworkManagerError.invalidResponse(statusCode: nil)))
                    return
                }
                
                // 요청이 실패한 경우
                let statusCode = response.statusCode
                guard (200..<300).contains(statusCode) else {
                    let networkManagerError = NetworkManagerError.invalidResponse(statusCode: statusCode)
                    observer(.failure(networkManagerError))
                    return
                }
                
                // data 디코딩에 실패한 경우
                guard let data,
                      let decodable = try? JSONDecoder().decode(T.self,from: data) else {
                    observer(.failure(NetworkManagerError.decodeFailed))
                    return
                }
                
                // 정상적인 데이터 반환
                observer(.success(decodable))
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
        
        if let image = imageCache.image(forKey: url) {
            let single = Single<UIImage>.create { observer in
                observer(.success(image))
                return Disposables.create()
            }
            return single
        }
        
        // 컴플리션을 통해 응답에 대한 observer를 실행시키는 Single 객체
        let single = Single<UIImage>.create(subscribe: { observer in
            let request = URLRequest(url: url)
            URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
                guard let self else {
                    observer(.failure(NetworkManagerError.unknown))
                    return }
                
                if let error {
                    observer(.failure(error))
                    return
                }

                // HTTP 가 아닌 응답 경우
                guard let response = response as? HTTPURLResponse else {
                    observer(.failure(NetworkManagerError.invalidResponse(statusCode: nil)))
                    return
                }
                
                // 요청이 실패한 경우
                let statusCode = response.statusCode
                guard (200..<300).contains(statusCode) else {
                    let networkManagerError = NetworkManagerError.invalidResponse(statusCode: statusCode)
                    observer(.failure(networkManagerError))
                    return
                }
                
                guard let data,
                      let image = UIImage(data: data) else {
                    observer(.failure(NetworkManagerError.unknown))
                    return }
                
                observer(.success(image))
                imageCache.setImage(image, forKey: url)
            }.resume()
            
            return Disposables.create()
        })
        return single
    }
    
    private func cacheData(url: URL) -> Single<Data>? {
        guard let data = UserDefaults.standard.data(forKey: cachingKey(url)) else { return nil }
        
        let single = Single<Data>.create(subscribe: { observer in
            observer(.success(data))
            return Disposables.create()
        })
        
        return single
    }
    
    private func saveData(url: URL, data: UIImage) {
        UserDefaults.standard.set(data, forKey: cachingKey(url))
    }
    
    private func cachingKey(_ url: URL) -> String {
        return "NetworkManager" + url.absoluteString
    }
}
