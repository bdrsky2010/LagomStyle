//
//  PrimaryColorRoundedButton.swift
//  LagomStyle
//
//  Created by Minjae Kim on 6/16/24.
//

import UIKit

import SnapKit

final class PrimaryColorRoundedButton: UIButton, ConfigureViewProtocol {
    
    init() {
        super.init(frame: .zero)
    }
    
    convenience init(title: String) {
        self.init()
        configuration = .filled()
        configuration?.cornerStyle = .capsule
        configuration?.attributedTitle = AttributedString(
            NSAttributedString(string: title, attributes: [NSAttributedString.Key.font: LagomStyle.Font.bold14,
                                                           NSAttributedString.Key.foregroundColor: LagomStyle.Color.lagomWhite]))
        configuration?.baseBackgroundColor = LagomStyle.Color.lagomPrimaryColor
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
