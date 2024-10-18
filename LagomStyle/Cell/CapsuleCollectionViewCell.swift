//
//  CapsuleCollectionViewCell.swift
//  LagomStyle
//
//  Created by Minjae Kim on 10/18/24.
//

import UIKit
import SnapKit

final class CapsuleCollectionViewCell: BaseCollectionViewCell {
    private let queryLabel = UILabel.blackRegular13()
    
    let removeButton: UIButton = {
        let button = UIButton(type: .system)
        button.configuration = .plain()
        button.configuration?.image = UIImage(systemName: LagomStyle.SystemImage.xmark)
        button.configuration?.baseForegroundColor = LagomStyle.AssetColor.lagomBlack
        button.configuration?.preferredSymbolConfigurationForImage = .init(font: UIFont.systemFont(ofSize: 13))
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.layer.cornerRadius = contentView.bounds.height / 2
    }
    
    override func configureHierarchy() {
        contentView.addSubview(queryLabel)
        contentView.addSubview(removeButton)
    }
    
    override func configureLayout() {
        queryLabel.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(8)
            make.leading.equalToSuperview().inset(12)
        }
        
        removeButton.snp.makeConstraints { make in
            make.centerY.equalTo(queryLabel.snp.centerY)
            make.leading.equalTo(queryLabel.snp.trailing).offset(12)
            make.trailing.equalToSuperview().inset(12)
        }
    }
}

extension CapsuleCollectionViewCell {
    func configureContent(text: String) {
        queryLabel.text = text
    }
}
