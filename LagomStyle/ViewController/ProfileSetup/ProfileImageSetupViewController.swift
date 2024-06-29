//
//  ProfileImageSetupViewController.swift
//  LagomStyle
//
//  Created by Minjae Kim on 6/16/24.
//

import UIKit

import SnapKit

final class ProfileImageSetupViewController: BaseViewController {
    private let profileImageSetupView = ProfileImageSetupView()
    
    var selectedImageIndex: Int?
    var pfImageSetupType: LagomStyle.PFSetupOption?
    var delegate: PFImageSetupDelegate?
    
    override func loadView() {
        view = profileImageSetupView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigation()
        configureContent()
        configureCollectionView()
    }
    
    override func configureView() {
        super.configureView()
    }
    
    override func configureNavigation() {
        guard let setupType = pfImageSetupType else { return }
        navigationItem.title = setupType.title
        
        configureNavigationBackButton()
    }
    
    private func configureContent() {
        guard let selectedImageIndex else { return }
        
        let image = LagomStyle.Image.profile(index: selectedImageIndex).imageName
        profileImageSetupView.profileImage.configureContent(image: image)
    }
    
    private func configureCollectionView() {
        profileImageSetupView.imageCollectionView.delegate = self
        profileImageSetupView.imageCollectionView.dataSource = self
        
        profileImageSetupView.imageCollectionView.register(ImageCollectionViewCell.self,
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
            profileImageSetupView.profileImage.configureContent(image: LagomStyle.Image.profile(index: index).imageName)
            
            selectedImageIndex = index
            
            if let selectedImageIndex {
                delegate?.setupPFImage(selectedIndex: selectedImageIndex)
            }
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
