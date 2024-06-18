//
//  Divider.swift
//  LagomStyle
//
//  Created by Minjae Kim on 6/19/24.
//

import UIKit

final class Divider: UIView {
    
    init(backgroundColor: UIColor) {
        super.init(frame: .zero)
        self.backgroundColor = backgroundColor
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
