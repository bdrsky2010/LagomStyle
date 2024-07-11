//
//  ProfileImageSetupViewController.swift
//  LagomStyle
//
//  Created by Minjae Kim on 6/16/24.
//

import UIKit

import SnapKit

final class ProfileImageSetupViewController: BaseViewController {
    private let profileImageSetupView: ProfileImageSetupView
    private let viewModel: ProfileImageSetupViewModel
    private let pfImageSetupOption: LagomStyle.PFSetupOption
    
    weak var delegate: PFImageSetupDelegate?
    
    init(pfImageSetupOption: LagomStyle.PFSetupOption, selectedImageIndex: Int) {
        self.profileImageSetupView = ProfileImageSetupView()
        self.viewModel = ProfileImageSetupViewModel(selectedImageIndex: selectedImageIndex)
        self.pfImageSetupOption = pfImageSetupOption
        super.init()
    }
    
    override func loadView() {
        view = profileImageSetupView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindData()
        viewModel.inputViewDidLoadTrigger.value = ()
    }
    
    override func configureView() {
        super.configureView()
    }
    
    private func bindData() {
        viewModel.outputDidConfigureProfileImage.bind { [weak self] index in
            guard let self, let index else { return }
            let image = LagomStyle.AssetImage.profile(index: index).imageName
            profileImageSetupView.profileImage.configureContent(image: image)
            
            navigationItem.title = pfImageSetupOption.title
            configureNavigationBackButton()
            configureCollectionView()
        }
        
        viewModel.outputDidSelectedImageIndex.bind { [weak self] index in
            guard let self, let index else { return }
            profileImageSetupView.profileImage.configureContent(image: LagomStyle.AssetImage.profile(index: index).imageName)
            delegate?.setupPFImage(selectedIndex: index)
        }
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
        guard let selectedImageIndex = viewModel.inputSelectedImageIndex.value, index != selectedImageIndex else { return }
        
        if let originSelectedCell = collectionView.cellForItem(at: IndexPath(row: selectedImageIndex, section: 0)) as? ImageCollectionViewCell {
            originSelectedCell.changeContentStatus(imageSelectType: .unselect)
        }
        
        if let newSelectedCell = collectionView.cellForItem(at: IndexPath(row: index, section: 0)) as? ImageCollectionViewCell {
            newSelectedCell.changeContentStatus(imageSelectType: .select)
            viewModel.inputSelectedImageIndex.value = index
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 12
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCollectionViewCell.identifier, for: indexPath) as? ImageCollectionViewCell else {
            return UICollectionViewCell()
        }
        let index = indexPath.row
        let image = LagomStyle.AssetImage.profile(index: index).imageName
        if let selectedImageIndex = viewModel.inputSelectedImageIndex.value {
            cell.configureContent(image: image, imageSelectType: selectedImageIndex == index ? .select : .unselect)
        }
        return cell
    }
}
