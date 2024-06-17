//
//  SettingTableViewCell.swift
//  LagomStyle
//
//  Created by Minjae Kim on 6/17/24.
//

import UIKit

import SnapKit

final class SettingTableViewCell: UITableViewCell, ConfigureViewProtocol {
    
    private let optionLabel: UILabel = {
        let label = UILabel()
        label.font = LagomStyle.Font.regular15
        label.textColor = LagomStyle.Color.lagomBlack
        return label
    }()
    
    private let basketImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(named: LagomStyle.Image.like(selected: true).imageName)
        return imageView
    }()
    
    private let likeProductCountLabel: UILabel = {
        let label = UILabel()
        label.font = LagomStyle.Font.regular14
        label.textColor = LagomStyle.Color.lagomBlack
        return label
    }()
    
    private let seperator: UIView = {
        let view = UIView()
        view.backgroundColor = LagomStyle.Color.lagomGray
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureView()
    }
    
    private func configureView() {
        configureHierarchy()
        configureLayout()
    }
    
    func configureHierarchy() {
        contentView.addSubview(optionLabel)
        contentView.addSubview(basketImageView)
        contentView.addSubview(likeProductCountLabel)
        contentView.addSubview(seperator)
    }
    
    func configureLayout() {
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
        likeProductCountLabel.text = "\(likeProductsCount)개의 상품"
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
