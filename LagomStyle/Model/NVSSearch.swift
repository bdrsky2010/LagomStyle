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
    var items: [NVSProduct]
}

// MARK: NAVER Shopping Product Data Model
struct NVSProduct: Codable {
    var title: String
    let link: String
    let image: String
    let lprice: String
    let mallName: String
    let productId: String
}

// MARK: NAVER Shopping Search Sort Options
enum NVSSSort: CaseIterable {
    case sim
    case date
    case asc
    case dsc
    
    var parameter: String {
        return String(describing: self)
    }
    
    var segmentedTitle: String {
        switch self {
        case .sim:
            return "정확도"
        case .date:
            return "날짜순"
        case .asc:
            return "가격높은순"
        case .dsc:
            return "가격낮은순"
        }
    }
}
