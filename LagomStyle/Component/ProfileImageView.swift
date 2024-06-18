//
//  ProfileImageView.swift
//  LagomStyle
//
//  Created by Minjae Kim on 6/16/24.
//

import UIKit

import SnapKit

final class ProfileImageView: UIView, ConfigureViewProtocol {
    
    private let profileImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let cameraBackground: UIView = {
        let view = UIView()
        view.backgroundColor = LagomStyle.Color.lagomPrimaryColor
        return view
    }()
    
    private let cameraImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: LagomStyle.SystemImage.cameraFill)
        imageView.tintColor = LagomStyle.Color.lagomWhite
        imageView.backgroundColor = .clear
        imageView.preferredSymbolConfiguration = .init(pointSize: 14)
        return imageView
    }()
    
    init() {
        super.init(frame: .zero)
        configureView()
    }
    
    convenience init(imageSelectType: LagomStyle.PFImageSelectType) {
        self.init()
        
        configureView(imageSelectType: imageSelectType)
    }
    
    convenience init(image: String, imageSelectType: LagomStyle.PFImageSelectType) {
        self.init()
        
        configureView(image: image, imageSelectType: imageSelectType)
    }
    
    override func layoutSubviews() {
        profileImage.layer.cornerRadius = bounds.width / 2
        cameraBackground.layer.cornerRadius = bounds.width * 0.3 / 2
    }
    
    func configureView() {
        configureHierarchy()
        configureLayout()
    }
    
    func configureView(imageSelectType: LagomStyle.PFImageSelectType) {
        configureHierarchy()
        configureLayout()
        configureUI(imageSelectType: imageSelectType)
    }
    
    func configureView(image: String, imageSelectType: LagomStyle.PFImageSelectType) {
        configureHierarchy()
        configureLayout()
        configureUI(imageSelectType: imageSelectType)
        configureContent(image: image)
    }
    
    func configureHierarchy() {
        addSubview(profileImage)
        addSubview(cameraBackground)
        cameraBackground.addSubview(cameraImage)
    }
    
    func configureLayout() {
        
        profileImage.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        cameraBackground.snp.makeConstraints { make in
            make.trailing.bottom.equalToSuperview()
            make.width.height.equalToSuperview().multipliedBy(0.3)
        }
        
        cameraImage.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    func configureUI(imageSelectType: LagomStyle.PFImageSelectType) {
        let type = imageSelectType
        
        profileImage.layer.borderColor = type.imageConfigure.borderColor
        profileImage.layer.borderWidth = type.imageConfigure.borderWidth
        profileImage.layer.opacity = type.imageConfigure.opacity
        
        cameraBackground.isHidden = type.imageConfigure.isCameraHidden
        cameraImage.isHidden = type.imageConfigure.isCameraHidden
    }
    
    func configureContent(image: String) {
        profileImage.image = UIImage(named: image)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
