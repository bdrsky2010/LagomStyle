//
//  NetworkHelper.swift
//  LagomStyle
//
//  Created by Minjae Kim on 6/24/24.
//

import UIKit

enum NetworkError: Error {
    case unknown
    case noData
    case failedRequest
    case invalidData
    case invalidClientResponse
    case invalidServerResponse
    
    var alertTitle: String {
        switch self {
        case .unknown:
            return "알 수 없는 에러"
        case .noData:
            return "존재하지 않는 데이터"
        case .failedRequest:
            return "요청 실패"
        case .invalidData:
            return "알 수 없는 데이터"
        case .invalidClientResponse:
            return "클라이언트 요청 에러"
        case .invalidServerResponse:
            return "서버 에러"
        }
    }
    
    var alertMessage: String {
        switch self {
        case .unknown:
            return "알 수 없는 에러로 데이터를 받아오지 못하였습니다...🤔"
        case .noData:
            return "데이터가 존재하지 않아 에러가 발생하였습니다...🥲"
        case .failedRequest:
            return "요청에 실패하여 데이터를 받아오지 못하였습니다...🥺"
        case .invalidData:
            return "알 수 없는 데이터로 인해 에러가 발생하였습니다...😥"
        case .invalidClientResponse:
            return "클라이언트에서의 네트워크 연결 혹은 입력값이 잘못되어 데이터를 받아오지 못하였습니다...😭"
        case .invalidServerResponse:
            return "서버의 문제가 생겨 데이터를 받아오지 못하였습니다...😤"
        }
    }
}

class NetworkHelper {
    static let shared = NetworkHelper()
    
    private init() { }
    
    func requestAPI<T: Decodable>(urlRequest: URLRequest?, of type: T.Type, completionHandler: @escaping (Result<T, NetworkError>) -> Void) {
        guard let urlRequest else {
            print("Failed URLRequest")
            completionHandler(.failure(.failedRequest))
            return
        }
        
        URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            guard error == nil else {
                print("Failed Request")
                completionHandler(.failure(.failedRequest))
                return
            }
            
            guard let data else {
                completionHandler(.failure(.noData))
                return
            }
            
            guard let response = response as? HTTPURLResponse else {
                print("Unable Response")
                completionHandler(.failure(.invalidClientResponse))
                return
            }
            
            switch response.statusCode {
            case 200..<300:
                break
            case 400..<500:
                print("failed response")
                completionHandler(.failure(.invalidClientResponse))
                return
            case 500..<600:
                print("failed response")
                completionHandler(.failure(.invalidServerResponse))
                return
            default:
                print("failed response")
                completionHandler(.failure(.unknown))
                return
            }
            
            let decoder = JSONDecoder()
            do {
                let result = try decoder.decode(T.self, from: data)
                completionHandler(.success(result))
            } catch {
                completionHandler(.failure(.invalidData))
            }
        }.resume()
    }
}

extension NetworkHelper {
    func requestAPIWithAlertOnViewController<T: Decodable>(api: APIURL, of type: T.Type, viewController: UIViewController, completionHandler: @escaping (Result<T, NetworkError>) -> Void) {
        DispatchQueue.global().async { [weak self] in
            guard let self else { return }
            requestAPI(urlRequest: api.urlRequest, of: type.self) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let value):
                        completionHandler(.success(value))
                    case .failure(let error):
                        completionHandler(.failure(error))
                        viewController.presentNetworkErrorAlert(error: error)
                    }
                }
            }
        }
    }
}
