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
    
    func callRequest(_ term: String) -> Observable<ItunesResponse> {
        
        let result = Observable<ItunesResponse>.create { observer in
            
            guard var urlComponents = URLComponents(string: APIURL.url) else {
                observer.onError(APIError.invalidURL)
                return Disposables.create()
            }
            
            let queryItems: [URLQueryItem] = [
                URLQueryItem(name: "term", value: term),
                URLQueryItem(name: "country", value: "KR"),
                URLQueryItem(name: "media", value: "software")
            ]
            urlComponents.queryItems = queryItems
            
            guard let url = urlComponents.url else {
                observer.onError(APIError.invalidURL)
                return Disposables.create()
            }
            
            let request = URLRequest(url: url, timeoutInterval: 5)
            URLSession.shared.dataTask(with: request) { data, response, error in
                if error != nil {
                    print("에러 값 존재")
                    observer.onError(APIError.unknownResponse)
                    return
                }
                
                guard let response = response as? HTTPURLResponse,
                      (200..<300).contains(response.statusCode) else {
                    print("상태코드 에러")
                    observer.onError(APIError.statusError)
                    return
                }
                
                if let data = data, let value = try? JSONDecoder().decode(ItunesResponse.self, from: data) {
                    dump(value)
                    observer.onNext(value)
                    observer.onCompleted()
                } else {
                    print("디코딩 에러")
                    observer.onError(APIError.decodingError)
                }
            }.resume()
            
            return Disposables.create()
        }
        
        return result
    }
    
}
