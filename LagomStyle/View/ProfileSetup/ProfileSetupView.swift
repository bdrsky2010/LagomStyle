//
//  ProfileSetupView.swift
//  LagomStyle
//
//  Created by Minjae Kim on 6/25/24.
//

import UIKit

import SnapKit


final class ProfileSetupView: BaseView {
    
    let profileImageView = ProfileImageView(imageSelectType: .selected)
    let nicknameTextField: UITextField = {
        let textField = UITextField()
        textField.attributedPlaceholder = NSAttributedString(
            string: LagomStyle.Phrase.profileSettingPlaceholder,
            attributes: [NSAttributedString.Key.font: LagomStyle.SystemFont.bold16,
                         NSAttributedString.Key.foregroundColor: LagomStyle.AssetColor.lagomLightGray])
        textField.borderStyle = .none
        return textField
    }()
    
    let warningLabel = UILabel.primaryRegular13()
    let completeButton = PrimaryColorRoundedButton(title: LagomStyle.Phrase.profileSettingComplete)
    
    private let textFieldUnderBar = Divider(backgroundColor: LagomStyle.AssetColor.lagomLightGray)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func configureView() {
        super.configureView()
    }
    
    override func configureHierarchy() {
        addSubview(profileImageView)
        addSubview(nicknameTextField)
        addSubview(textFieldUnderBar)
        addSubview(warningLabel)
        addSubview(completeButton)
    }
    
    override func configureLayout() {
        profileImageView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(20)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(snp.width).multipliedBy(0.3)
        }
        
        nicknameTextField.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.bottom).offset(20)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(24)
            make.height.equalTo(44)
        }
        
        textFieldUnderBar.snp.makeConstraints { make in
            make.top.equalTo(nicknameTextField.snp.bottom)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(20)
            make.height.equalTo(1)
        }
        
        warningLabel.snp.makeConstraints { make in
            make.top.equalTo(textFieldUnderBar.snp.bottom).offset(12)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(20)
        }
        
        completeButton.snp.makeConstraints { make in
            make.top.equalTo(warningLabel.snp.bottom).offset(32)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(20)
            make.height.equalTo(44)
        }
    }
}
