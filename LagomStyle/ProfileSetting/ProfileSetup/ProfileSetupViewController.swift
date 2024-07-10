//
//  ProfileNicknameSetupViewController.swift
//  LagomStyle
//
//  Created by Minjae Kim on 6/16/24.
//

import UIKit

import SnapKit

final class ProfileSetupViewController: BaseViewController {
    
    private let profileSetupView = ProfileSetupView()
    private let profileSetupViewModel = ProfileSetupViewModel()
    
    var pfSetupType: LagomStyle.PFSetupOption?
    
    override func loadView() {
        view = profileSetupView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCompleteButton()
    }
    
    override func configureView() {
        bindData()
        configureNavigation()
        configureContent()
        configureProfileImageView()
        configureTextField()
    }
    
    override func configureNavigation() {
        guard let setupType = pfSetupType else { return }
        
        navigationController?.navigationBar.isHidden = false
        navigationItem.title = setupType.title
        
        if setupType == .edit {
            let rightBarButtonItem = UIBarButtonItem(title: "저장",
                                                     style: .plain,
                                                     target: self,
                                                     action: #selector(saveButtonClicked))
            navigationItem.rightBarButtonItem = rightBarButtonItem
        }
        
        configureNavigationBackButton()
    }
    
    @objc
    private func saveButtonClicked() {
        profileSetupViewModel.inputSaveDatabaseTrigger.value = pfSetupType
    }
    
    private func bindData() {
        profileSetupViewModel.outputIsCompleteButtonHidden.bind { [weak self] isHidden in
            guard let self ,let isHidden else { return }
            profileSetupView.completeButton.isHidden = isHidden
        }
        
        profileSetupViewModel.outputSelectedImage.bind { [weak self] image in
            guard let self else { return }
            profileSetupView.profileImageView.configureContent(image: image)
        }
        
        profileSetupViewModel.outputTrimmedText.bind { [weak self] text in
            guard let self else { return }
            profileSetupView.nicknameTextField.text = text
        }
        
        profileSetupViewModel.outputIsValidNickname.bind { [weak self] isValidNickname in
            guard let self, let pfSetupType else { return }
            switch pfSetupType {
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
        
        profileSetupViewModel.outputValidError.bind { [weak self] error in
            guard let self else { return }
            profileSetupView.warningLabel.textColor = LagomStyle.AssetColor.lagomPrimaryColor
            switch error {
            case .numberOfCharacter:
                profileSetupView.warningLabel.text = LagomStyle.Phrase.numberOfCharacterX
            case .specialCharacter:
                profileSetupView.warningLabel.text = LagomStyle.Phrase.specialCharacterX
            case .includeNumbers:
                profileSetupView.warningLabel.text = LagomStyle.Phrase.includeNumbers
            case nil:
                return
            }
        }
        
        profileSetupViewModel.outputPushNavigationTrigger.bind { [weak self] imageIndex in
            guard let self else { return }
            let profileImageSetupViewController = ProfileImageSetupViewController()
            profileImageSetupViewController.pfImageSetupType = pfSetupType
            profileImageSetupViewController.selectedImageIndex = imageIndex
            profileImageSetupViewController.delegate = self
            navigationController?.pushViewController(profileImageSetupViewController, animated: true)
        }
        
        profileSetupViewModel.outputChangeRootViewTrigger.bind { [weak self] _ in
            guard let self else { return }
            let mainViewController = MainTabBarController()
            changeRootViewController(rootViewController: mainViewController)
        }
        
        profileSetupViewModel.outputPopViewTrigger.bind { [weak self] _ in
            guard let self else { return }
            navigationController?.popViewController(animated: true)
        }
    }
    
    func configureContent() {
        profileSetupViewModel.inputViewDidLoadTrigger.value = pfSetupType
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
        profileSetupViewModel.inputNickname.value = text
        profileSetupView.completeButton.addTarget(self, action: #selector(completeButtonClicked), for: .touchUpInside)
    }
    
    @objc
    private func completeButtonClicked() {
        profileSetupViewModel.inputSaveDatabaseTrigger.value = pfSetupType
    }
    
    @objc
    private func profileImageTapped() {
        profileSetupViewModel.inputImageTapTrigger.value = ()
    }
}

extension ProfileSetupViewController: UITextFieldDelegate {
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        guard let text = textField.text else { return }
        profileSetupViewModel.inputDidChangeText.value = text
        profileSetupViewModel.inputNickname.value = text
    }
}

extension ProfileSetupViewController: PFImageSetupDelegate {
    func setupPFImage(selectedIndex: Int) {
        profileSetupViewModel.inputSelectedImageIndex.value = selectedIndex
    }
}
