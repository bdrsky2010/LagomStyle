//
//  ImageCollectionViewCell.swift
//  LagomStyle
//
//  Created by Minjae Kim on 6/16/24.
//

import UIKit

import SnapKit

final class ImageCollectionViewCell: UICollectionViewCell, ConfigureViewProtocol {
    
    let profileImage = ProfileImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureView()
    }
    
    private func configureView() {
        configureHierarchy()
        configureLayout()
    }
    
    func configureHierarchy() {
        contentView.addSubview(profileImage)
    }
    
    func configureLayout() {
        profileImage.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func configureContent(image: String, imageSelectType: LagomStyle.PFImageSelectType) {
        profileImage.configureContent(image: image)
        profileImage.configureUI(imageSelectType: imageSelectType)
    }
    
    func changeContentStatus(imageSelectType: LagomStyle.PFImageSelectType) {
        profileImage.configureUI(imageSelectType: imageSelectType)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
