//
//  NSObject+.swift
//  LagomStyle
//
//  Created by Minjae Kim on 6/30/24.
//

import Foundation

protocol ReuseIdentifier {
    static var identifier: String { get }
}

extension NSObject: ReuseIdentifier {
    static var identifier: String {
        return self.description()
    }
}
