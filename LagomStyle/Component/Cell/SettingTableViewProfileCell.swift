//
//  SettingTableViewProfileCell.swift
//  LagomStyle
//
//  Created by Minjae Kim on 6/17/24.
//

import UIKit

import SnapKit

final class SettingTableViewProfileCell: BaseTableViewCell {
    private let profileImageView = ProfileImageView(imageSelectType: .select)
    private let nicknameLabel = UILabel.blackBold16()
    private let signUpDateLabel = UILabel.grayRegular13()
    
    private let pushImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: LagomStyle.SystemImage.chevronRight)
        imageView.tintColor = LagomStyle.Color.lagomGray
        return imageView
    }()
    
    private let seperator = Divider(backgroundColor: LagomStyle.Color.lagomGray)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    override func configureHierarchy() {
        contentView.addSubview(profileImageView)
        contentView.addSubview(nicknameLabel)
        contentView.addSubview(signUpDateLabel)
        contentView.addSubview(pushImageView)
        contentView.addSubview(seperator)
    }
    
    override func configureLayout() {
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
}
