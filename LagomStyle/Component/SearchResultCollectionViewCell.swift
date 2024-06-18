//
//  SearchResultCollectionViewCell.swift
//  LagomStyle
//
//  Created by Minjae Kim on 6/17/24.
//

import UIKit

import Kingfisher
import SnapKit

final class SearchResultCollectionViewCell: UICollectionViewCell, ConfigureViewProtocol {
    
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
    
    private let basketForgroundView: UIView = {
        let view = UIView()
        return view
    }()
    
    private let mallNameLabel: UILabel = {
        let label = UILabel()
        label.font  = LagomStyle.Font.regular13
        label.textColor = LagomStyle.Color.lagomLightGray
        return label
    }()
    
    private let productTitleLabel: UILabel = {
        let label = UILabel()
        label.font  = LagomStyle.Font.regular14
        label.textColor = LagomStyle.Color.lagomBlack
        label.numberOfLines = 2
        return label
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.font  = LagomStyle.Font.black16
        label.textColor = LagomStyle.Color.lagomBlack
        return label
    }()
    
    var row: Int?
    var isLiske: Bool?
    var delegate: NVSSearchDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }
    
    private func configureView() {
        configureHierarchy()
        configureLayout()
        configureBasket()
    }
    
    func configureHierarchy() {
        contentView.addSubview(thumbnailImageView)
        contentView.addSubview(basketBackgroundView)
        basketBackgroundView.addSubview(basketImageView)
        basketBackgroundView.addSubview(basketForgroundView)
        
        contentView.addSubview(mallNameLabel)
        contentView.addSubview(productTitleLabel)
        contentView.addSubview(priceLabel)
    }
    
    func configureLayout() {
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
        
        basketForgroundView.snp.makeConstraints { make in
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
    
    private func configureBasket() {
        basketForgroundView.isUserInteractionEnabled = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(likeButtonTapped))
        basketForgroundView.addGestureRecognizer(tapGesture)
    }
    
    @objc
    private func likeButtonTapped() {
        isLiske?.toggle()
        changeBasketContent()
    }
    
    private func configureBasketContent(isLike: Bool) {
        basketBackgroundView.backgroundColor = isLike ? LagomStyle.Color.lagomWhite.withAlphaComponent(1) : LagomStyle.Color.lagomBlack.withAlphaComponent(0.5)
        basketImageView.image = UIImage(named: LagomStyle.Image.like(selected: isLike).imageName)
    }
    
    private func changeBasketContent() {
        guard let isLiske, let row else { return }
        
        configureBasketContent(isLike: isLiske)
        delegate?.setLikeButtonImageToggle(row: row, isLike: isLiske)
    }
    
    func configureContent(product: NVSProduct) {
        if let url = URL(string: product.imageUrlString) {
            thumbnailImageView.configureImageWithKF(url: url)
        }
        
        if let isLiske {
            configureBasketContent(isLike: isLiske)
        }
        
        mallNameLabel.text = product.mallName
        productTitleLabel.text = product.title
        
        if let price = Int(product.lowPrice)?.formatted() {
            priceLabel.text = price + "원"
        }
    }
    
    func highlightingWithQuery(query: String?) {
        productTitleLabel.attributedText = productTitleLabel.text?.changedSearchTextColor(query)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
