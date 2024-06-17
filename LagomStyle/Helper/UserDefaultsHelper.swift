//
//  UserDefaultsHelper.swift
//  LagomStyle
//
//  Created by Minjae Kim on 6/16/24.
//

import Foundation

// MARK: get, set, remove UserDefaults Data
enum UserDefaultsHelper {
    
    @UserDefaultWrapper(key: LagomStyle.UserDefaultsKey.isOnboarding)
    static var isOnboarding: Bool?
    
    @UserDefaultWrapper(key: LagomStyle.UserDefaultsKey.nickname)
    static var nickname: String?
    
    @UserDefaultWrapper(key: LagomStyle.UserDefaultsKey.profileImageIndex)
    static var profileImageIndex: Int?
    
    @UserDefaultWrapper(key: LagomStyle.UserDefaultsKey.recentSearchQueries)
    static var recentSearchQueries: [String]?
    
    @UserDefaultWrapper(key: LagomStyle.UserDefaultsKey.likeProducts)
    static var likeProducts: [NVSProduct]?
    
    static func getUserDefaults(forKey: String) -> Any? {
        return UserDefaults.standard.object(forKey: forKey)
    }
    
    static func setUserDefaults<T>(value: T, forKey: String) {
        UserDefaults.standard.set(value, forKey: forKey)
    }
    
    static func removeUsetDefaults(forKey: String) {
        UserDefaults.standard.removeObject(forKey: forKey)
    }
}

@propertyWrapper
struct UserDefaultWrapper<T: Codable> {
    private let key: String
    private let userDefaults = UserDefaults.standard

    init(key: String) {
        self.key = key
    }
    
    var wrappedValue: T? {
        get {
            if let data = userDefaults.object(forKey: key) as? Data {
                if let value = try? JSONDecoder().decode(T.self, from: data) {
                    return value
                }
            }
            return nil
        }
        set {
            if let encoded = try? JSONEncoder().encode(newValue) {
                userDefaults.setValue(encoded, forKey: key)
            }
        }
    }
}
