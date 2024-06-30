//
//  ImageCollectionViewCell.swift
//  LagomStyle
//
//  Created by Minjae Kim on 6/16/24.
//

import UIKit

import SnapKit

final class ImageCollectionViewCell: BaseCollectionViewCell {
    let profileImage = ProfileImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureView()
    }
    
    override func configureHierarchy() {
        contentView.addSubview(profileImage)
    }
    
    override func configureLayout() {
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
}
