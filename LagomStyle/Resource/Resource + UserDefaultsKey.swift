//
//  Resource + UserDefaultsKey.swift
//  LagomStyle
//
//  Created by Minjae Kim on 6/30/24.
//

import Foundation

// MARK: App에서 사용되는 UserDefaults Key
extension LagomStyle {
    enum UserDefaultsKey {
        static let isOnboarding = "isOnboarding"
        static let nickname = "nickname"
        static let signUpDate = "signUpDate"
        static let profileImageIndex = "profileImageIndex"
        static let recentSearchQueries = "recentSearchQueries"
        static let likeProducts = "likeProducts"
    }
}
