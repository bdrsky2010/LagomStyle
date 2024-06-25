//
//  NetworkHelper.swift
//  LagomStyle
//
//  Created by Minjae Kim on 6/24/24.
//

import Foundation

import Alamofire

class NetworkHelper {
    static let shared = NetworkHelper()
    
    private init() { }
    
    func requestAPI<T: Decodable>(urlString: String,
                                         method: HTTPMethod,
                                         parameters: Parameters,
                                         encoding: URLEncoding,
                                         headers: HTTPHeaders,
                                         of type: T.Type,
                                         completionHandler: @escaping (Result<T, Error>) -> Void) {
        AF.request(urlString,
                   method: method,
                   parameters: parameters,
                   encoding: encoding,
                   headers: headers)
        .responseDecodable(of: type.self) { response in
            switch response.result {
            case .success(let value):
                completionHandler(.success(value))
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }
}
