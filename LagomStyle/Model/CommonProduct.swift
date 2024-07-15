//
//  CommonProduct.swift
//  LagomStyle
//
//  Created by Minjae Kim on 7/11/24.
//

import Foundation

// NVSProduct 타입과 Basket 타입을 연결해주는 공통 타입
struct CommonProduct {
    let id: String
    let title: String
    let mallName: String
    let lowPrice: String
    let imageUrlString: String
    let webUrlString: String
    
    init(id: String, title: String, mallName: String, lowPrice: String, imageUrlString: String, webUrlString: String) {
        self.id = id
        self.title = title
        self.mallName = mallName
        self.lowPrice = lowPrice
        self.imageUrlString = imageUrlString
        self.webUrlString = webUrlString
    }
    
    init(contentsOf product: NVSProduct) {
        self.init(id: product.productID, title: product.title, mallName: product.mallName, lowPrice: product.lowPrice, imageUrlString: product.imageUrlString, webUrlString: product.urlString)
    }
    
    init(contentsOf basket: Basket) {
        self.init(id: basket.id, title: basket.name, mallName: basket.mallName, lowPrice: basket.lowPrice, imageUrlString: basket.imageUrlString, webUrlString: basket.webUrlString)
    }
}
