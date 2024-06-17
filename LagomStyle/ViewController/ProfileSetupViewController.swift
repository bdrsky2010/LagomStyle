//
//  ProfileNicknameSetupViewController.swift
//  LagomStyle
//
//  Created by Minjae Kim on 6/16/24.
//

import UIKit

import SnapKit

final class ProfileSetupViewController: UIViewController, ConfigureViewProtocol {
    
    private let profileImageView = ProfileImageView(imageSelectType: .selected)
    
    private let nicknameTextField: UITextField = {
        let textField = UITextField()
        textField.attributedPlaceholder = NSAttributedString(
            string: LagomStyle.phrase.profileSettingPlaceholder,
            attributes: [NSAttributedString.Key.font: LagomStyle.Font.bold16,
                         NSAttributedString.Key.foregroundColor: LagomStyle.Color.lagomLightGray])
        textField.borderStyle = .none
        return textField
    }()
    
    private let textFieldUnderBar: UIView = {
        let view = UIView()
        view.backgroundColor = LagomStyle.Color.lagomLightGray
        return view
    }()
    
    private let warningLabel: UILabel = {
        let label = UILabel()
        label.font = LagomStyle.Font.regular13
        label.textColor = LagomStyle.Color.lagomPrimaryColor
        return label
    }()
    
    private lazy var completeButton = PrimaryColorRoundedButton(title: LagomStyle.phrase.profileSettingComplete) { [weak self] in
        guard let self, let text = nicknameTextField.text else { return }
        
        UserDefaultsHelper.isOnboarding = true
        UserDefaultsHelper.nickname = text
        UserDefaultsHelper.profileImageIndex = selectedImageIndex
        UserDefaultsHelper.signUpDate = Date.convertString
        
        let mainViewController = MainTabBarController()
        changeRootViewController(rootViewController: mainViewController)
    }
    
    private var isEnabled = false
    private var selectedImageIndex = Int.random(in: 0...11)
    var pfSetupType: LagomStyle.PFSetupOption?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
    }
    
    private func configureView() {
        view.backgroundColor = LagomStyle.Color.lagomWhite
        
        configureNavigation()
        configureHierarchy()
        configureLayout()
        configureUI()
        configureContent()
        configureProfileImageView()
        configureTextField()
    }
    
    func configureNavigation() {
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
        guard let text = nicknameTextField.text else { return }
        
        UserDefaultsHelper.nickname = text
        UserDefaultsHelper.profileImageIndex = selectedImageIndex
        navigationController?.popViewController(animated: true)
    }
    
    func configureHierarchy() {
        view.addSubview(profileImageView)
        view.addSubview(nicknameTextField)
        view.addSubview(textFieldUnderBar)
        view.addSubview(warningLabel)
        view.addSubview(completeButton)
    }
    
    func configureLayout() {
        
        profileImageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(view.snp.width).multipliedBy(0.3)
        }
        
        nicknameTextField.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.bottom).offset(20)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(24)
            make.height.equalTo(44)
        }
        
        textFieldUnderBar.snp.makeConstraints { make in
            make.top.equalTo(nicknameTextField.snp.bottom)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(1)
        }
        
        warningLabel.snp.makeConstraints { make in
            make.top.equalTo(textFieldUnderBar.snp.bottom).offset(12)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        completeButton.snp.makeConstraints { make in
            make.top.equalTo(warningLabel.snp.bottom).offset(32)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(44)
        }
    }
    
    func configureUI() {
        completeButton.isEnabled = isEnabled
    }
    
    func configureContent() {
        if pfSetupType == .edit,
            let profileImageIndex = UserDefaultsHelper.profileImageIndex,
            let nickname = UserDefaultsHelper.nickname {
            completeButton.isHidden = true
            selectedImageIndex = profileImageIndex
            nicknameTextField.text = nickname
            checkNickname(text: nickname)
        }
        let image = LagomStyle.Image.profile(index: selectedImageIndex).imageName
        profileImageView.configureContent(image: image)
    }
    
    private func configureTextField() {
        nicknameTextField.delegate = self
    }
    
    private func configureProfileImageView() {
        profileImageView.isUserInteractionEnabled = true
        
        let tapGestuer = UITapGestureRecognizer(target: self, action: #selector(profileImageTapped))
        profileImageView.addGestureRecognizer(tapGestuer)
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
            completeButton.isEnabled = isEnabled
            navigationItem.rightBarButtonItem?.isEnabled = isEnabled
        }
        checkNickname(text: text)
    }
    
    private func checkNickname(text: String) {
        for char in text {
            let string = String(char)
            
            guard text.count >= 2, text.count < 10 else {
                warningLabel.text = LagomStyle.phrase.numberOfCharacterX
                isEnabled = false
                return
            }
            
            if let _ = string.range(of: "^[@#$%]*$", options: .regularExpression) {
                warningLabel.text = LagomStyle.phrase.specialCharacterX
                isEnabled = false
                return
            }
            
            if let _ = string.range(of: "^[0-9]*$", options: .regularExpression) {
                warningLabel.text = LagomStyle.phrase.includeNumbers
                isEnabled = false
                return
            }
        }
        isEnabled = true
        warningLabel.text = LagomStyle.phrase.availableNickname
    }
}

extension ProfileSetupViewController: PFImageSetupDelegate {
    
    func setupPFImage(selectedIndex: Int) {
        let image = LagomStyle.Image.profile(index: selectedIndex).imageName
        profileImageView.configureContent(image: image)
        selectedImageIndex = selectedIndex
    }
}
