//
//  NVSSearch.swift
//  LagomStyle
//
//  Created by Minjae Kim on 6/15/24.
//

import Foundation

// MARK: NAVER Shopping Search Data Model
struct NVSSearch: Codable {
    let total: Int
    let start: Int
    let display: Int
    var products: [NVSProduct]
    
    enum CodingKeys: String, CodingKey {
        case total
        case start
        case display
        case products = "items"
    }
}

// MARK: NAVER Shopping Product Data Model
struct NVSProduct: Codable, Equatable {    
    var title: String
    let urlString: String
    let imageUrlString: String
    let lowPrice: String
    let mallName: String
    let productID: String
    
    enum CodingKeys: String, CodingKey {
        case title
        case urlString = "link"
        case imageUrlString = "image"
        case lowPrice = "lprice"
        case mallName
        case productID = "productId"
    }
    
    static func == (lhs: NVSProduct, rhs: NVSProduct) -> Bool {
        return lhs.productID == rhs.productID
    }
}

// MARK: NAVER Shopping Search Sort Options
enum NVSSSort: CaseIterable {
    case sim
    case date
    case dsc
    case asc
    
    var parameter: String {
        return String(describing: self)
    }
    
    var segmentedTitle: String {
        switch self {
        case .sim:
            return "정확도"
        case .date:
            return "날짜순"
        case .dsc:
            return "가격높은순"
        case .asc:
            return "가격낮은순"
        }
    }
}
