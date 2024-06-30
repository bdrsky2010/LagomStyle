//
//  UIView+.swift
//  LagomStyle
//
//  Created by Minjae Kim on 6/30/24.
//

import UIKit

extension UIView {
    static var screenSize: CGSize? {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return nil }
        return windowScene.screen.bounds.size
    }
}
