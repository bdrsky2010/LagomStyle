//
//  CapsuleTapActionLabel.swift
//  LagomStyle
//
//  Created by Minjae Kim on 6/16/24.
//

import UIKit

import SnapKit

final class CapsuleTapActionButton: UIView, ConfigureViewProtocol {
    
    private let label = UILabel.blackRegular14()
    
    init() {
        super.init(frame: .zero)
    }
    
    convenience init(title: String, tag: Int) {
        self.init()
        self.tag = tag
        
        label.text = title
        clipsToBounds = true
        configureView()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = bounds.height / 2
    }
    
    func configureView() {
        configureHierarchy()
        configureLayout()
        configureUI()
    }
    
    func configureHierarchy() {
        addSubview(label)
    }
    
    func configureLayout() {
        label.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(8)
            make.horizontalEdges.equalToSuperview().inset(12)
        }
    }
    
    func configureUI() {
        layer.borderColor = LagomStyle.Color.lagomLightGray.cgColor
        
        if tag == 0 {
            selectUI()
        } else {
            unSelectUI()
        }
    }
    
    func selectUI() {
        label.textColor = LagomStyle.Color.lagomWhite
        backgroundColor = LagomStyle.Color.lagomDarkGray
        layer.borderWidth = 0
    }
    
    func unSelectUI() {
        label.textColor = LagomStyle.Color.lagomBlack
        backgroundColor = LagomStyle.Color.lagomWhite
        layer.borderWidth = 1
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
