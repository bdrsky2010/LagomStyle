//
//  UIViewController+.swift
//  LagomStyle
//
//  Created by Minjae Kim on 6/13/24.
//

import UIKit

// MARK: UIViewController extension Method: get identifier
extension UIViewController {
    
    static var identifier: String {
        return String(describing: self)
    }
}

// MARK: UIViewController extension Method: get, set, remove UserDefaults Data
extension UIViewController {
    
    func getUserDefaults(forKey: String) -> Any? {
        return UserDefaults.standard.object(forKey: forKey)
    }
    
    func setUserDefaults<T>(value: T, forKey: String) {
        UserDefaults.standard.set(value, forKey: forKey)
    }
    
    func removeUsetDefaults(forKey: String) {
        UserDefaults.standard.removeObject(forKey: forKey)
    }
}
