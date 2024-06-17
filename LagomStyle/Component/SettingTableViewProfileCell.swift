//
//  SettingTableViewProfileCell.swift
//  LagomStyle
//
//  Created by Minjae Kim on 6/17/24.
//

import UIKit

import SnapKit

final class SettingTableViewProfileCell: UITableViewCell, ConfigureViewProtocol {
    
    private let profileImageView = ProfileImageView(imageSelectType: .select)
    
    private let nicknameLabel: UILabel = {
        let label = UILabel()
        label.font = LagomStyle.Font.bold16
        label.textColor = LagomStyle.Color.lagomBlack
        return label
    }()
    
    private let signUpDateLabel: UILabel = {
        let label = UILabel()
        label.font = LagomStyle.Font.regular13
        label.textColor = LagomStyle.Color.lagomGray
        return label
    }()
    
    private let pushImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: LagomStyle.SystemImage.chevronRight)
        imageView.tintColor = LagomStyle.Color.lagomGray
        return imageView
    }()
    
    private let seperator: UIView = {
        let view = UIView()
        view.backgroundColor = LagomStyle.Color.lagomGray
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureView()
    }
    
    private func configureView() {
        configureHierarchy()
        configureLayout()
    }
    
    func configureHierarchy() {
        contentView.addSubview(profileImageView)
        contentView.addSubview(nicknameLabel)
        contentView.addSubview(signUpDateLabel)
        contentView.addSubview(pushImageView)
        contentView.addSubview(seperator)
    }
    
    func configureLayout() {
        profileImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.width.height.equalTo(contentView.snp.height).multipliedBy(0.5)
            make.centerY.equalToSuperview()
        }
        
        nicknameLabel.snp.makeConstraints { make in
            make.leading.equalTo(profileImageView.snp.trailing).offset(20)
            make.bottom.equalTo(profileImageView.snp.centerY).offset(-2)
            make.trailing.equalTo(pushImageView.snp.leading).offset(-20)
        }
        
        signUpDateLabel.snp.makeConstraints { make in
            make.leading.equalTo(profileImageView.snp.trailing).offset(20)
            make.top.equalTo(profileImageView.snp.centerY).offset(2)
            make.trailing.equalTo(pushImageView.snp.leading).offset(-20)
        }
        
        pushImageView.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-20)
            make.centerY.equalToSuperview()
            make.width.equalTo(20)
            make.height.equalTo(30)
        }
        
        seperator.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(1)
        }
    }
    
    func configureContent() {
        guard let profileImageIndex = UserDefaultsHelper.profileImageIndex else { return }
        guard let nickname = UserDefaultsHelper.nickname else { return }
        guard let signUpDate = UserDefaultsHelper.signUpDate else { return }
        
        profileImageView.configureContent(image: LagomStyle.Image.profile(index: profileImageIndex).imageName)
        nicknameLabel.text = nickname
        signUpDateLabel.text = signUpDate + " 가입"
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
