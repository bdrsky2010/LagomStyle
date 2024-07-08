//
//  ProfileNicknameSetupViewController.swift
//  LagomStyle
//
//  Created by Minjae Kim on 6/16/24.
//

import UIKit

import RealmSwift
import SnapKit

enum ValidationError: Error {
    case numberOfCharacter
    case specialCharacter
    case includeNumbers
}

final class ProfileSetupViewController: BaseViewController {
    
    private let profileSetupView = ProfileSetupView()
    private let userTableRepository = RealmRepository()
    
    private var isEnabled = false
    private var selectedImageIndex = Int.random(in: 0...11)
    
    var pfSetupType: LagomStyle.PFSetupOption?
    
    override func loadView() {
        view = profileSetupView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCompleteButton()
    }
    
    override func configureView() {
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
        guard let text = profileSetupView.nicknameTextField.text else { return }
        
//        UserDefaultsHelper.nickname = text
//        UserDefaultsHelper.profileImageIndex = selectedImageIndex
        if let user = userTableRepository.fetchItem(of: UserTable.self).first {
            let value: [String: Any] = ["id": user.id, "nickname": text, "proflieImageIndex": selectedImageIndex]
            userTableRepository.updateItem(of: UserTable.self, value: value)
        }
        navigationController?.popViewController(animated: true)
    }
    
    func configureContent() {
//        if pfSetupType == .edit,
//            let profileImageIndex = UserDefaultsHelper.profileImageIndex,
//            let nickname = UserDefaultsHelper.nickname {
//            profileSetupView.completeButton.isHidden = true
//            selectedImageIndex = profileImageIndex
//            profileSetupView.nicknameTextField.text = nickname
//            completeValidateNickname(nickname: nickname)
//        }
        if pfSetupType == .edit, let user = userTableRepository.fetchItem(of: UserTable.self).first {
            profileSetupView.completeButton.isHidden = true
            selectedImageIndex = user.proflieImageIndex
            profileSetupView.nicknameTextField.text = user.nickname
            completeValidateNickname(nickname: user.nickname)
        }
        let image = LagomStyle.AssetImage.profile(index: selectedImageIndex).imageName
        profileSetupView.profileImageView.configureContent(image: image)
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
        profileSetupView.completeButton.isEnabled = isEnabled
        profileSetupView.completeButton.addTarget(self, action: #selector(completeButtonClicked), for: .touchUpInside)
    }
    
    @objc
    private func completeButtonClicked() {
        guard let text = profileSetupView.nicknameTextField.text else { return }
        
        UserDefaultsHelper.isOnboarding = true
//        UserDefaultsHelper.nickname = text
//        UserDefaultsHelper.profileImageIndex = selectedImageIndex
//        UserDefaultsHelper.signUpDate = Date.convertString
        
        let user = UserTable(nickname: text, proflieImageIndex: selectedImageIndex, signupDate: Date())
        userTableRepository.createItem(user)
        userTableRepository.printDatebaseURL()
        
        let mainViewController = MainTabBarController()
        changeRootViewController(rootViewController: mainViewController)
    }
    
    @objc
    private func profileImageTapped() {
        let profileImageSetupViewController = ProfileImageSetupViewController()
        profileImageSetupViewController.pfImageSetupType = .setup
        profileImageSetupViewController.selectedImageIndex = selectedImageIndex
        profileImageSetupViewController.delegate = self
        
        navigationController?.pushViewController(profileImageSetupViewController, animated: true)
    }
}

extension ProfileSetupViewController: UITextFieldDelegate {
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        guard let text = textField.text else { return }
        
        defer {
            profileSetupView.completeButton.isEnabled = isEnabled
            navigationItem.rightBarButtonItem?.isEnabled = isEnabled
        }
        completeValidateNickname(nickname: text)
    }
    
    private func completeValidateNickname(nickname: String) {
        do {
            let isEnabled = try validateNickname(nickname: nickname)
            
            if isEnabled {
                self.isEnabled = isEnabled
                profileSetupView.warningLabel.text = LagomStyle.Phrase.availableNickname
                profileSetupView.warningLabel.textColor = LagomStyle.AssetColor.lagomBlack
            }
            
        } catch ValidationError.numberOfCharacter {
            profileSetupView.warningLabel.textColor = LagomStyle.AssetColor.lagomPrimaryColor
            profileSetupView.warningLabel.text = LagomStyle.Phrase.numberOfCharacterX
            isEnabled = false
        } catch ValidationError.specialCharacter {
            profileSetupView.warningLabel.textColor = LagomStyle.AssetColor.lagomPrimaryColor
            profileSetupView.warningLabel.text = LagomStyle.Phrase.specialCharacterX
            isEnabled = false
        } catch ValidationError.includeNumbers {
            profileSetupView.warningLabel.textColor = LagomStyle.AssetColor.lagomPrimaryColor
            profileSetupView.warningLabel.text = LagomStyle.Phrase.includeNumbers
            isEnabled = false
        } catch {
            profileSetupView.warningLabel.textColor = LagomStyle.AssetColor.lagomPrimaryColor
            profileSetupView.warningLabel.text = LagomStyle.Phrase.unknownError
            isEnabled = false
        }
    }
    
    private func validateNickname(nickname: String) throws -> Bool {
        guard nickname.count >= 2, nickname.count < 10 else {
            throw ValidationError.numberOfCharacter
        }
        
        for char in nickname {
            let string = String(char)
            if let _ = string.range(of: "^[@#$%]*$", options: .regularExpression) {
                throw ValidationError.specialCharacter
            }
            if let _ = string.range(of: "^[0-9]*$", options: .regularExpression) {
                throw ValidationError.includeNumbers
            }
        }
        return true
    }
}

extension ProfileSetupViewController: PFImageSetupDelegate {
    
    func setupPFImage(selectedIndex: Int) {
        let image = LagomStyle.AssetImage.profile(index: selectedIndex).imageName
        profileSetupView.profileImageView.configureContent(image: image)
        selectedImageIndex = selectedIndex
    }
}
