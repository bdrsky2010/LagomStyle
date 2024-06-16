//
//  ProfileImageSetupViewController.swift
//  LagomStyle
//
//  Created by Minjae Kim on 6/16/24.
//

import UIKit

import SnapKit

final class ProfileImageSetupViewController: UIViewController, ConfigureViewProtocol {
    
    private let profileImage = ProfileImageView(imageSelectType: .selected)
    
    private lazy var imageCollectionView: UICollectionView = {
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
    
    var pfImageSetupType: LagomStyle.PFSetupOption?
    var selectedImageIndex: Int?
    var pfImageSetupDelegate: PFImageSetupDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
    }
    
    private func configureView() {
        view.backgroundColor = LagomStyle.Color.lagomWhite
        
        configureNavigation()
        configureHierarchy()
        configureLayout()
        configureContent()
        configureCollectionView()
    }
    
    func configureNavigation() {
        guard let setupType = pfImageSetupType else { return }
        navigationItem.title = setupType.title
        
        configureNavigationBackButton()
    }
    
    func configureHierarchy() {
        
        view.addSubview(profileImage)
        view.addSubview(imageCollectionView)
    }
    
    func configureLayout() {
        
        profileImage.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.width.height.equalTo(view.snp.width).multipliedBy(0.3)
            make.centerX.equalTo(view.safeAreaLayoutGuide)
        }
        
        imageCollectionView.snp.makeConstraints { make in
            make.top.greaterThanOrEqualTo(profileImage.snp.bottom).offset(20)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(view.safeAreaLayoutGuide).multipliedBy(0.4)
            make.centerY.equalTo(view.safeAreaLayoutGuide.snp.centerY)
        }
    }
    
    func configureContent() {
        guard let selectedImageIndex else { return }
        
        let image = LagomStyle.Image.profile(index: selectedImageIndex).imageName
        profileImage.configureContent(image: image)
    }
    
    private func configureCollectionView() {
        imageCollectionView.delegate = self
        imageCollectionView.dataSource = self
        
        imageCollectionView.register(ImageCollectionViewCell.self,
                                     forCellWithReuseIdentifier: ImageCollectionViewCell.identifier)
    }
}

extension ProfileImageSetupViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let index = indexPath.row
        
        guard index != selectedImageIndex else { return }
        
        if let selectedImageIndex, let originSelectedCell = collectionView.cellForItem(at: IndexPath(row: selectedImageIndex, section: 0)) as? ImageCollectionViewCell {
            originSelectedCell.changeContentStatus(imageSelectType: .unselect)
        }
        
        if let newSelectedCell = collectionView.cellForItem(at: IndexPath(row: index, section: 0)) as? ImageCollectionViewCell {
            newSelectedCell.changeContentStatus(imageSelectType: .select)
            profileImage.configureContent(image: LagomStyle.Image.profile(index: index).imageName)
            
            if let selectedImageIndex {
                pfImageSetupDelegate?.setupPFImage(selectedIndex: selectedImageIndex)
            }
            
            selectedImageIndex = index
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 12
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCollectionViewCell.identifier, for: indexPath) as? ImageCollectionViewCell else {  return UICollectionViewCell() }
        
        let index = indexPath.row
        
        let image = LagomStyle.Image.profile(index: index).imageName
        
        if let selectedImageIndex, selectedImageIndex == index {
            cell.configureContent(image: image, imageSelectType: .select)
            
        } else {
            cell.configureContent(image: image, imageSelectType: .unselect)
        }
        
        return cell
    }
}
