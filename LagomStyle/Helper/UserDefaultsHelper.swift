//
//  UserDefaultsHelper.swift
//  LagomStyle
//
//  Created by Minjae Kim on 6/16/24.
//

import Foundation

// MARK: get, set, remove UserDefaults Data
enum UserDefaultsHelper {
    
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
