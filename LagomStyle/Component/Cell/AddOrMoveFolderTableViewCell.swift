//
//  AddOrMoveFolderTableViewCell.swift
//  LagomStyle
//
//  Created by Minjae Kim on 7/9/24.
//

import UIKit

import SnapKit

final class AddOrMoveFolderTableViewCell: BaseTableViewCell {
    
    private let titleLabel = UILabel.blackBold16()
    private let checkBoxImageView = UIImageView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    override func configureHierarchy() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(checkBoxImageView)
    }
    
    override func configureLayout() {
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.centerY.equalToSuperview()
            make.trailing.equalTo(checkBoxImageView.snp.trailing).offset(-20)
        }
        
        checkBoxImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-20)
        }
    }
    
    private func configureUI() {
        checkBoxImageView.preferredSymbolConfiguration = .init(pointSize: 20, weight: .bold)
        checkBoxImageView.tintColor = LagomStyle.AssetColor.lagomPrimaryColor
    }
    
    func configureTitle(title: String) {
        titleLabel.text = title
    }
    
    func configureImage(checkBoxImage: UIImage?) {
        checkBoxImageView.image = checkBoxImage
    }
}
