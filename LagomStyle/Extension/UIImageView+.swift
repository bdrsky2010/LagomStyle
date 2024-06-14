//
//  UIImageView+.swift
//  LagomStyle
//
//  Created by Minjae Kim on 6/13/24.
//

import UIKit
import Kingfisher

extension UIImageView {
    
    // MARK: Kingfisher 코드를 좀 더 편하게 사용하기 위한 메서드
    func configureImageWithKF(url: URL) {
        self.kf.indicatorType = .activity
        self.kf.setImage(
            with: url,
            options: [.cacheOriginalImage])
    }
}
