//
//  EmptyResultView.swift
//  LagomStyle
//
//  Created by Minjae Kim on 6/18/24.
//

import UIKit

import SnapKit

final class EmptyResultView: UIView, ConfigureViewProtocol {
    
    private let emptyImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.image = UIImage(named: LagomStyle.Image.empty.imageName)
        return imageView
    }()
    
    private let emptyText: UILabel = {
        let label = UILabel()
        label.font = LagomStyle.Font.black16
        label.textColor = LagomStyle.Color.lagomBlack
        return label
    }()
    
    private var text: String
    
    init(text: String) {
        self.text = text
        super.init(frame: .zero)
        configureView()
    }
    
    private func configureView() {
        configureHierarchy()
        configureLayout()
        configureContent()
    }
    
    func configureHierarchy() {
        addSubview(emptyImage)
        addSubview(emptyText)
    }
    
    func configureLayout() {
        emptyImage.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(16)
            make.height.equalToSuperview().multipliedBy(0.5)
        }
        
        emptyText.snp.makeConstraints { make in
            make.top.equalTo(emptyImage.snp.bottom)
            make.centerX.equalToSuperview()
        }
    }
    
    func configureContent() {
        emptyText.text = text
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}