//
//  NVSSearch.swift
//  LagomStyle
//
//  Created by Minjae Kim on 6/15/24.
//

import Foundation

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
