//
//  CapsuleTapActionLabel.swift
//  LagomStyle
//
//  Created by Minjae Kim on 6/16/24.
//

import UIKit

import SnapKit

final class CapsuleTapActionButton: UIView, ConfigureViewProtocol {
    
    private let label = UILabel()
    
    private var isTapped = false
    
//    var tapAction: ((_ sender: CapsuleTapActionButton) -> Void)?
    var tapAction: (() -> Void)?
    
    init() {
        super.init(frame: .zero)
    }
    
    convenience init(title: String, tag: Int, tapAction: (() -> Void)?) {
        self.init()
        self.tag = tag
        self.tapAction = tapAction
        
        label.text = title
        
        clipsToBounds = true
        
        isUserInteractionEnabled = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tappedAction))
        addGestureRecognizer(tapGesture)
        
        configureView()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = bounds.height / 2
    }
    
    @objc private func tappedAction() {
        resultFilteringButtonTapped()
        
        tapAction?()
    }
    
    private func configureView() {
        configureHierarchy()
        configureLayout()
        configureUI()
    }
    
    func configureHierarchy() {
        addSubview(label)
    }
    
    func configureLayout() {
        label.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(8)
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
    
    private func resultFilteringButtonTapped() {
        isTapped.toggle()
        
        if isTapped {
            selectUI()
        } else {
            unSelectUI()
        }
    }
    
    private func selectUI() {
        label.textColor = LagomStyle.Color.lagomWhite
        backgroundColor = LagomStyle.Color.lagomDarkGray
        layer.borderWidth = 0
    }
    
    private func unSelectUI() {
        label.textColor = LagomStyle.Color.lagomBlack
        backgroundColor = LagomStyle.Color.lagomWhite
        layer.borderWidth = 1
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
