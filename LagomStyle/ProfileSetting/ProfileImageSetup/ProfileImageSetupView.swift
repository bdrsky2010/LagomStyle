//
//  ProfileImageSetupView.swift
//  LagomStyle
//
//  Created by Minjae Kim on 6/25/24.
//

import UIKit

import SnapKit

final class ProfileImageSetupView: BaseView {
    
    let profileImage = ProfileImageView(imageSelectType: .selected)
    
    lazy var imageCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            let screenWidth = windowScene.screen.bounds.width
            
            let sectionSpacing: CGFloat = 16
            let cellSpacing: CGFloat = 16
            let width = screenWidth - (sectionSpacing * 2) - (cellSpacing * 3)
            
            layout.itemSize = CGSize(width: width / 4, height: width / 4)
            layout.minimumLineSpacing = 8
            layout.minimumInteritemSpacing = 8
            layout.sectionInset = UIEdgeInsets(
                top: sectionSpacing, left: sectionSpacing, bottom: sectionSpacing, right: sectionSpacing)
        }
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.isScrollEnabled = false
        
        return collectionView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func configureView() {
        super.configureView()
    }
    
    override func configureHierarchy() {
        addSubview(profileImage)
        addSubview(imageCollectionView)
    }
    
    override func configureLayout() {
        profileImage.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(20)
            make.width.height.equalTo(snp.width).multipliedBy(0.3)
            make.centerX.equalTo(safeAreaLayoutGuide)
        }
        
        imageCollectionView.snp.makeConstraints { make in
            make.top.greaterThanOrEqualTo(profileImage.snp.bottom).offset(20)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide)
            make.height.equalTo(safeAreaLayoutGuide).multipliedBy(0.4)
            make.centerY.equalTo(safeAreaLayoutGuide.snp.centerY)
        }
    }
}
