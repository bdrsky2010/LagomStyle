//
//  BackgroundImageView.swift
//  LagomStyle
//
//  Created by Minjae Kim on 6/16/24.
//

import UIKit

final class BackgroundImageView: UIImageView {
    
    init(image: UIImage) {
        super.init(image: image)
        contentMode = .scaleAspectFill
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
