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
        contentView.addSubview(priceLabel)
        contentView.addSubview(productTitleLabel)
        contentView.addSubview(mallNameLabel)
        contentView.addSubview(thumbnailImageView)
        contentView.addSubview(basketBackgroundView)
        basketBackgroundView.addSubview(basketImageView)
        basketBackgroundView.addSubview(basketForgroundView)
    }
    
    func configureLayout() {
        priceLabel.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.horizontalEdges.equalToSuperview()
        }
        
        productTitleLabel.snp.makeConstraints { make in
            make.bottom.equalTo(priceLabel.snp.top).offset(-8)
            make.horizontalEdges.equalToSuperview()
        }
        
        mallNameLabel.snp.makeConstraints { make in
            make.bottom.equalTo(productTitleLabel.snp.top).offset(-8)
            make.horizontalEdges.equalToSuperview()
        }
        
        thumbnailImageView.snp.makeConstraints { make in
            make.bottom.equalTo(mallNameLabel.snp.top).offset(-8)
            make.top.horizontalEdges.equalToSuperview()
        }
        
        basketBackgroundView.snp.makeConstraints { make in
            make.bottom.equalTo(thumbnailImageView.snp.bottom).offset(-16)
            make.trailing.equalTo(thumbnailImageView.snp.trailing).offset(-16)
            make.width.height.equalTo(24)
        }
        
        basketImageView.snp.makeConstraints { make in
            make.horizontalEdges.verticalEdges.equalToSuperview().inset(4)
        }
        
        basketForgroundView.snp.makeConstraints { make in
            make.horizontalEdges.verticalEdges.equalToSuperview().inset(4)
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
    
    private func changeBasketContent() {
        guard let isLiske else { return }
        basketBackgroundView.backgroundColor = isLiske ? LagomStyle.Color.lagomWhite : LagomStyle.Color.lagomBlack
        basketBackgroundView.layer.opacity = isLiske ? 1 : 0.5
        basketImageView.image = UIImage(named: LagomStyle.Image.like(selected: isLiske).imageName)
    }
    
    func configureContent(product: NVSProduct) {
        if let url = URL(string: product.image) {
            thumbnailImageView.configureImageWithKF(url: url)
        }
        changeBasketContent()
        
        mallNameLabel.text = product.mallName
        productTitleLabel.text = product.title
        
        if let price = Int(product.lprice)?.formatted() {
            priceLabel.text = price + "원"
        }
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
