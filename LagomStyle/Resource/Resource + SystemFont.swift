//
//  Resource + SystemFont.swift
//  LagomStyle
//
//  Created by Minjae Kim on 6/30/24.
//

import UIKit.UIFont

// MARK: App에서 사용되는 Text들의 SystemFont
extension LagomStyle {
    enum SystemFont {
        static let regular13 = UIFont.systemFont(ofSize: 13)
        static let regular14 = UIFont.systemFont(ofSize: 14)
        static let regular15 = UIFont.systemFont(ofSize: 15)
        static let regular16 = UIFont.systemFont(ofSize: 16)
        
        static let bold13 = UIFont.boldSystemFont(ofSize: 13)
        static let bold14 = UIFont.boldSystemFont(ofSize: 14)
        static let bold15 = UIFont.boldSystemFont(ofSize: 15)
        static let bold16 = UIFont.boldSystemFont(ofSize: 16)
        
        static let black13 = UIFont.systemFont(ofSize: 13, weight: .black)
        static let black14 = UIFont.systemFont(ofSize: 14, weight: .black)
        static let black15 = UIFont.systemFont(ofSize: 15, weight: .black)
        static let black16 = UIFont.systemFont(ofSize: 16, weight: .black)
        static let black50 = UIFont.systemFont(ofSize: 50, weight: .black)
    }
}
