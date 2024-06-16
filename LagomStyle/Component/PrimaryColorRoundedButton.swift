//
//  PrimaryColorRoundedButton.swift
//  LagomStyle
//
//  Created by Minjae Kim on 6/16/24.
//

import UIKit

import SnapKit

final class PrimaryColorRoundedButton: UIButton, ConfigureViewProtocol {
    
    var clickAction: (() -> Void)?
    
    init() {
        super.init(frame: .zero)
    }
    
    convenience init(title: String, clickAction: (() -> Void)? = nil) {
        self.init()
        self.clickAction = clickAction
        
        configuration = .filled()
        configuration?.cornerStyle = .capsule
        configuration?.attributedTitle = AttributedString(
            NSAttributedString(string: title, attributes: [NSAttributedString.Key.font: LagomStyle.Font.black16,
                                                           NSAttributedString.Key.foregroundColor: LagomStyle.Color.lagomWhite]))
        configuration?.baseBackgroundColor = LagomStyle.Color.lagomPrimaryColor
        
        addTarget(self, action: #selector(buttonClicked), for: .touchUpInside)
    }
    
    @objc
    private func buttonClicked() {
        clickAction?()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
