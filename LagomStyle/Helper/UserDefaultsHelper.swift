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
    
    static func removeUserDefaults(forKey: String) {
        UserDefaults.standard.removeObject(forKey: forKey)
    }
    
    static func removeAllUserDefaults() {
        UserDefaults.standard.dictionaryRepresentation().keys.forEach {
            UserDefaults.standard.removeObject(forKey: $0)
        }
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
