//
//  NetworkHelper.swift
//  LagomStyle
//
//  Created by Minjae Kim on 6/24/24.
//

import Foundation

import Alamofire

enum NetworkHelper {
    static func requestAPI<T: Decodable>(urlString: String,
                                         method: HTTPMethod,
                                         parameters: Parameters,
                                         encoding: URLEncoding,
                                         headers: HTTPHeaders,
                                         of type: T.Type,
                                         success successHandler: @escaping (T) -> Void,
                                         failure failureHandler: @escaping (Error) -> Void) {
        AF.request(urlString,
                   method: method,
                   parameters: parameters,
                   encoding: encoding,
                   headers: headers)
        .responseDecodable(of: type.self) { response in
            switch response.result {
            case .success(let value):
                successHandler(value)
            case .failure(let error):
                failureHandler(error)
            }
        }
    }
}
