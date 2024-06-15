//
//  ViewController.swift
//  LagomStyle
//
//  Created by Minjae Kim on 6/13/24.
//

import UIKit

import Alamofire
import SnapKit

// MARK: NAVER Shopping Search Data Model
struct NVSSearch: Decodable {
    let total: Int
    let start: Int
    let display: Int
    var items: [NVSProduct]
}

// MARK: NAVER Shopping Product Data Model
struct NVSProduct: Decodable {
    var title: String
    let link: String
    let image: String
    let lprice: String
    let mallName: String
    let productId: String
}

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = LagomStyle.Color.lagomWhite
    }
    
    private func requestNVSSearchAPI(query: String, display: Int, start: Int, sort: String) {
        let parameters: Parameters = [
            "query": query,
            "display": display,
            "start": start,
            "sort": sort
        ]
        
        let headers: HTTPHeaders = [
            "X-Naver-Client-Id": APIKey.naverClientID,
            "X-Naver-Client-Secret": APIKey.naverClientSecret
        ]
        
        AF.request(APIUrl.naverShopping,
                   method: .get,
                   parameters: parameters,
                   encoding: URLEncoding.queryString,
                   headers: headers)
        .responseDecodable(of: NVSSearch.self) { response in
            switch response.result {
            case .success(let value):
                var value = value
                value.items.indices.forEach { i in
                    let title = value.items[i].title.removeHtmlTag
                    value.items[i].title = title
                }
                print(value)
            case .failure(let error):
                print(error)
            }
        }
    }
}

