//
//  CapsuleTapActionLabel.swift
//  LagomStyle
//
//  Created by Minjae Kim on 6/16/24.
//

import UIKit

import SnapKit

final class CapsuleTapActionButton: BaseView {
    
    private let label = UILabel.blackRegular14()
    
    init() {
        super.init(frame: .zero)
    }
    
    convenience init(title: String, tag: Int) {
        self.init()
        self.tag = tag
        
        label.text = title
        clipsToBounds = true
        configureButton()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = bounds.height / 2
    }
    
    override func configureHierarchy() {
        addSubview(label)
    }
    
    override func configureLayout() {
        label.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(8)
            make.horizontalEdges.equalToSuperview().inset(12)
        }
    }
    
    private func configureButton() {
        layer.borderColor = LagomStyle.AssetColor.lagomLightGray.cgColor
        
        if tag == 0 {
            selectUI()
        } else {
            unSelectUI()
        }
    }
    
    func selectUI() {
        label.textColor = LagomStyle.AssetColor.lagomWhite
        backgroundColor = LagomStyle.AssetColor.lagomDarkGray
        layer.borderWidth = 0
    }
    
    func unSelectUI() {
        label.textColor = LagomStyle.AssetColor.lagomBlack
        backgroundColor = LagomStyle.AssetColor.lagomWhite
        layer.borderWidth = 1
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
