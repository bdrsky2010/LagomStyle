//
//  Resource + Image.swift
//  LagomStyle
//
//  Created by Minjae Kim on 6/30/24.
//

import UIKit.UIImage

extension LagomStyle {
    // MARK: App에서 사용되는 Image Asset 이름
    enum AssetImage {
        case empty
        case launch
        case like(selected: Bool)
        case profile(index: Int)
        
        var imageName: String {
            switch self {
            case .empty:
                return String(describing: self)
            case .launch:
                return String(describing: self)
            case .like(let selected):
                return "like_\(selected ? "selected" : "unselected")"
            case .profile(let index):
                return "profile_\(index)"
            }
        }
    }
}
