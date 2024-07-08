//
//  FolderTableViewCell.swift
//  LagomStyle
//
//  Created by Minjae Kim on 7/8/24.
//

import UIKit

import SnapKit

final class FolderTableViewCell: BaseTableViewCell {
    
    private let titleLabel = UILabel.blackBold16()
    private let optionLabel = UILabel.blackRegular14()
    private let countLabel = UILabel.blackRegular14()
    private let forwardImageView = UIImageView()
    private let seperator = Divider(backgroundColor: LagomStyle.AssetColor.lagomGray)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }

    override func configureHierarchy() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(optionLabel)
        contentView.addSubview(countLabel)
        contentView.addSubview(forwardImageView)
        contentView.addSubview(seperator)
    }
    
    override func configureLayout() {
        titleLabel.snp.makeConstraints { make in
            make.bottom.equalTo(contentView.snp.centerY)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalTo(countLabel.snp.leading).offset(-20)
        }
        
        optionLabel.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.centerY)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalTo(countLabel.snp.leading).offset(-20)
        }
        
        countLabel.setContentHuggingPriority(.init(252), for: .horizontal)
        countLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalTo(forwardImageView.snp.leading).offset(-4)
        }
        
        forwardImageView.setContentHuggingPriority(.init(252), for: .horizontal)
        forwardImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-20)
        }
        
        seperator.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(1)
        }
    }
    
    func configureContent(title: String, option: String, count: Int) {
        titleLabel.text = title
        optionLabel.text = option
        countLabel.text = "\(count)개"
        forwardImageView.image = UIImage(systemName: LagomStyle.SystemImage.chevronRight)
        forwardImageView.tintColor = LagomStyle.AssetColor.lagomBlack
    }
}
