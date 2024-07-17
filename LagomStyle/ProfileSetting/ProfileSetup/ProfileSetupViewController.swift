//
//  ProfileNicknameSetupViewController.swift
//  LagomStyle
//
//  Created by Minjae Kim on 6/16/24.
//

import UIKit

import SnapKit

final class ProfileSetupViewController: BaseViewController {
    private let profileSetupView: ProfileSetupView
    private let viewModel: ProfileSetupViewModel
    private let pfSetupOption: LagomStyle.PFSetupOption
    
    init(pfSetupOption: LagomStyle.PFSetupOption) {
        self.profileSetupView = ProfileSetupView()
        self.viewModel = ProfileSetupViewModel()
        self.pfSetupOption = pfSetupOption
        super.init()
    }
    
    override func loadView() {
        view = profileSetupView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindData()
        viewModel.inputViewDidLoadTrigger.value = pfSetupOption
    }
    
    private func bindData() {
        viewModel.outputDidConfigureNavigation.bind { [weak self] title in
            guard let self else { return }
            navigationController?.navigationBar.isHidden = false
            navigationItem.title = pfSetupOption.title
            
            if pfSetupOption == .edit {
                let rightBarButtonItem = UIBarButtonItem(title: "저장",
                                                         style: .plain,
                                                         target: self,
                                                         action: #selector(saveButtonClicked))
                navigationItem.rightBarButtonItem = rightBarButtonItem
            }
            configureNavigationBackButton()
        }
        
        viewModel.outputDidConfigureView.bind { [weak self] _ in
            guard let self else { return }
            configureCompleteButton()
            configureProfileImageView()
            configureTextField()
        }
        
        viewModel.outputDidCheckIsEditOption.bind { [weak self] tuple in
            guard let self ,let tuple else { return }
            profileSetupView.completeButton.isHidden = tuple.isHidden
            profileSetupView.nicknameTextField.text = tuple.nickname
        }
        
        viewModel.outputDidSelectedImage.bind { [weak self] image in
            guard let self else { return }
            profileSetupView.profileImageView.configureContent(image: image)
        }
        
        viewModel.outputDidTrimmedText.bind { [weak self] text in
            guard let self else { return }
            profileSetupView.nicknameTextField.text = text
        }
        
        viewModel.outputDidCheckIsValidNickname.bind { [weak self] isValidNickname in
            guard let self else { return }
            switch pfSetupOption {
            case .edit:
                navigationItem.rightBarButtonItem?.isEnabled = isValidNickname
            case .setup:
                profileSetupView.completeButton.isEnabled = isValidNickname
            }
            
            if isValidNickname {
                profileSetupView.warningLabel.text = LagomStyle.Phrase.availableNickname
                profileSetupView.warningLabel.textColor = LagomStyle.AssetColor.lagomBlack
            }
        }
        
        viewModel.outputDidSendValidError.bind { [weak self] error in
            guard let self else { return }
            profileSetupView.warningLabel.textColor = LagomStyle.AssetColor.lagomPrimaryColor
            profileSetupView.warningLabel.text = error?.warningPhrase
        }
        
        viewModel.outputDidPushNavigationTrigger.bind { [weak self] imageIndex in
            guard let self, let imageIndex else { return }
            let profileImageSetupViewController = ProfileImageSetupViewController(pfImageSetupOption: pfSetupOption, selectedImageIndex: imageIndex)
            profileImageSetupViewController.delegate = self
            navigationController?.pushViewController(profileImageSetupViewController, animated: true)
        }
        
        viewModel.outputDidChangeRootViewTrigger.bind { [weak self] _ in
            guard let self else { return }
            let mainViewController = MainTabBarController()
            changeRootViewController(rootViewController: mainViewController)
        }
        
        viewModel.outputDidPopViewTrigger.bind { [weak self] _ in
            guard let self else { return }
            navigationController?.popViewController(animated: true)
        }
    }
    @objc
    private func saveButtonClicked() {
        viewModel.inputSaveDatabaseTrigger.value = pfSetupOption
    }
    
    private func configureTextField() {
        profileSetupView.nicknameTextField.delegate = self
    }
    
    private func configureProfileImageView() {
        profileSetupView.profileImageView.isUserInteractionEnabled = true
        
        let tapGestuer = UITapGestureRecognizer(target: self, action: #selector(profileImageTapped))
        profileSetupView.profileImageView.addGestureRecognizer(tapGestuer)
    }
    
    private func configureCompleteButton() {
        guard let text = profileSetupView.nicknameTextField.text else { return }
        viewModel.inputNickname.value = text
        profileSetupView.completeButton.addTarget(self, action: #selector(completeButtonClicked), for: .touchUpInside)
    }
    
    @objc
    private func completeButtonClicked() {
        viewModel.inputSaveDatabaseTrigger.value = pfSetupOption
    }
    
    @objc
    private func profileImageTapped() {
        viewModel.inputImageTapTrigger.value = ()
    }
}

extension ProfileSetupViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        guard let text = textField.text else { return }
        viewModel.inputChangeText.value = text
        viewModel.inputNickname.value = text
    }
}

extension ProfileSetupViewController: PFImageSetupDelegate {
    func setupPFImage(selectedIndex: Int) {
        viewModel.inputSelectedImageIndex.value = selectedIndex
    }
}
