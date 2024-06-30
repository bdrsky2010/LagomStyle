//
//  SettingTableViewCell.swift
//  LagomStyle
//
//  Created by Minjae Kim on 6/17/24.
//

import UIKit

import SnapKit

final class SettingTableViewCell: BaseTableViewCell {
    private let optionLabel = UILabel.blackRegular15()
    private let basketImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(named: LagomStyle.Image.like(selected: true).imageName)
        return imageView
    }()
    
    private let likeProductCountLabel = UILabel.blackRegular15()
    private let seperator = Divider(backgroundColor: LagomStyle.Color.lagomGray)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }

    override func configureHierarchy() {
        contentView.addSubview(optionLabel)
        contentView.addSubview(basketImageView)
        contentView.addSubview(likeProductCountLabel)
        contentView.addSubview(seperator)
    }
    
    override func configureLayout() {
        optionLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalTo(basketImageView.snp.trailing).offset(20)
        }
        
        likeProductCountLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-20)
        }
        
        basketImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalTo(likeProductCountLabel.snp.leading).offset(-2)
        }
        
        seperator.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(1)
        }
    }
    
    func configureContent(option: String, likeProductsCount: Int? = nil) {
        optionLabel.text = option
        
        guard let likeProductsCount else {
            likeProductCountLabel.isHidden = true
            basketImageView.isHidden = true
            return
        }
        likeProductCountLabel.isHidden = false
        basketImageView.isHidden = false
        
        let textCount = likeProductsCount == 0 ? 2 : (likeProductsCount / 10) + 2
        let attributedString = NSMutableAttributedString(string: "\(likeProductsCount)개의 상품")
        let blackAttribute = [NSAttributedString.Key.font: LagomStyle.Font.black15]
        attributedString.addAttributes(blackAttribute, range: NSRange(location: 0, length: textCount))
        likeProductCountLabel.attributedText = attributedString
    }
}
