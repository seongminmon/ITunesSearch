//
//  NetworkManager.swift
//  ITunesSearch
//
//  Created by 김성민 on 8/8/24.
//

import Foundation
import RxSwift

enum APIError: Error, LocalizedError {
    case invalidURL
    case unknownResponse
    case statusError
    case noData
    case decodingError
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            "유효하지 않은 URL"
        case .unknownResponse:
            "알 수 없는 응답"
        case .statusError:
            "상태코드 오류"
        case .noData:
            "데이터 없음"
        case .decodingError:
            "데이터 디코딩 에러"
        }
    }
}

final class NetworkManager {
    static let shared = NetworkManager()
    private init() {}
    
    func callRequest(_ term: String) -> Single<Result<ItunesResponse, APIError>> {
        
        return Single<Result<ItunesResponse, APIError>>.create { observer in
            
            guard var urlComponents = URLComponents(string: APIURL.url) else {
                observer(.success(.failure(APIError.invalidURL)))
                return Disposables.create()
            }
            let queryItems: [URLQueryItem] = [
                URLQueryItem(name: "term", value: term),
                URLQueryItem(name: "country", value: "KR"),
                URLQueryItem(name: "media", value: "software")
            ]
            urlComponents.queryItems = queryItems
            
            guard let url = urlComponents.url else {
                observer(.success(.failure(APIError.invalidURL)))
                return Disposables.create()
            }
            let request = URLRequest(url: url, timeoutInterval: 3)
            
            URLSession.shared.dataTask(with: request) { data, response, error in
                
                if error != nil {
                    observer(.success(.failure(APIError.unknownResponse)))
                    return
                }
                
                guard let response = response as? HTTPURLResponse,
                      (200..<300).contains(response.statusCode) else {
                    observer(.success(.failure(APIError.statusError)))
                    return
                }
                
                guard let data = data else {
                    observer(.success(.failure(APIError.noData)))
                    return
                }
                
                guard let value = try? JSONDecoder().decode(ItunesResponse.self, from: data) else {
                    observer(.success(.failure(APIError.decodingError)))
                    return
                }
                
                observer(.success(.success(value)))
                
            }.resume()
            
            return Disposables.create()
        }
    }
}
