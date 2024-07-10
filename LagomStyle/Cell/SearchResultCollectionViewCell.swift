//
//  SearchResultCollectionViewCell.swift
//  LagomStyle
//
//  Created by Minjae Kim on 6/17/24.
//

import UIKit

import Kingfisher
import SkeletonView
import SnapKit

final class SearchResultCollectionViewCell: BaseCollectionViewCell {
    private let thumbnailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 10
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let basketBackgroundView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 5
        view.clipsToBounds = true
        return view
    }()
    
    private let basketImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        return imageView
    }()
    
    private let mallNameLabel = UILabel.lightGrayRegular13()
    private let productTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = LagomStyle.AssetColor.lagomBlack
        label.font = LagomStyle.SystemFont.regular14
        label.numberOfLines = 2
        return label
    }()
    private let priceLabel = UILabel.blackBlack16()
    
    let basketForegroundButtonView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureSkeleton()
    }
    
    override func configureHierarchy() {
        contentView.addSubview(thumbnailImageView)
        contentView.addSubview(basketBackgroundView)
        basketBackgroundView.addSubview(basketImageView)
        basketBackgroundView.addSubview(basketForegroundButtonView)
        
        contentView.addSubview(mallNameLabel)
        contentView.addSubview(productTitleLabel)
        contentView.addSubview(priceLabel)
    }
    
    override func configureLayout() {
        thumbnailImageView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.7)
        }
        
        basketBackgroundView.snp.makeConstraints { make in
            make.bottom.equalTo(thumbnailImageView.snp.bottom).offset(-12)
            make.trailing.equalTo(thumbnailImageView.snp.trailing).offset(-12)
            make.width.height.equalTo(24)
        }
        
        basketImageView.snp.makeConstraints { make in
            make.horizontalEdges.verticalEdges.equalToSuperview().inset(4)
        }
        
        basketForegroundButtonView.snp.makeConstraints { make in
            make.horizontalEdges.verticalEdges.equalToSuperview().inset(4)
        }
        
        mallNameLabel.snp.makeConstraints { make in
            make.top.equalTo(thumbnailImageView.snp.bottom).offset(8)
            make.horizontalEdges.equalToSuperview()
        }
        
        productTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(mallNameLabel.snp.bottom).offset(8)
            make.horizontalEdges.equalToSuperview()
        }
        
        priceLabel.snp.makeConstraints { make in
            make.top.equalTo(productTitleLabel.snp.bottom).offset(8)
            make.horizontalEdges.equalToSuperview()
        }
    }
    
    private func configureSkeleton() {
        isSkeletonable = true
        thumbnailImageView.isSkeletonable = true
        basketBackgroundView.isSkeletonable = true
        basketImageView.isSkeletonable = true
        basketForegroundButtonView.isSkeletonable = true
        mallNameLabel.isSkeletonable = true
        productTitleLabel.isSkeletonable = true
        priceLabel.isSkeletonable = true
    }
    
    func configureContent(product: CommonProduct, isBasket: Bool) {
        if let url = URL(string: product.imageUrlString) {
            thumbnailImageView.configureImageWithKF(url: url)
        }
        if let price = Int(product.lowPrice)?.formatted() {
            priceLabel.text = price + "원"
        }
        mallNameLabel.text = product.mallName
        productTitleLabel.text = product.title
        configureBasketContent(isBasket: isBasket)
    }
    
    func configureBasketContent(isBasket: Bool) {
        basketBackgroundView.backgroundColor = isBasket ? LagomStyle.AssetColor.lagomWhite.withAlphaComponent(1) : LagomStyle.AssetColor.lagomBlack.withAlphaComponent(0.5)
        basketImageView.image = UIImage(named: LagomStyle.AssetImage.like(selected: isBasket).imageName)
    }
    
    func highlightingWithQuery(query: String?) {
        productTitleLabel.attributedText = productTitleLabel.text?.changedSearchTextColor(query)
    }
}
