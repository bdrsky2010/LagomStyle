//
//  OnboardingView.swift
//  LagomStyle
//
//  Created by Minjae Kim on 6/25/24.
//

import UIKit

import SnapKit

final class OnboardingView: BaseView {
    
    private let onboardingTitleBackground = UIView()
    
    private let onboardingTitle: UILabel = {
        let label = UILabel()
        label.text = LagomStyle.phrase.onBoardingAppTitle
        label.numberOfLines = 2
        label.font = LagomStyle.Font.black50
        label.textColor = LagomStyle.Color.lagomPrimaryColor
        label.textAlignment = .right
        return label
    }()
    
    private let backgroundImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: LagomStyle.Image.launch.imageName)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let startButton = PrimaryColorRoundedButton(title: LagomStyle.phrase.onBoardingStart)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func configureHierarchy() {
        addSubview(onboardingTitleBackground)
        onboardingTitleBackground.addSubview(onboardingTitle)
        
        addSubview(backgroundImage)
        addSubview(startButton)
    }
    
    override func configureLayout() {
        backgroundImage.snp.makeConstraints { make in
            make.center.equalTo(safeAreaLayoutGuide)
            make.width.height.equalTo(snp.height).multipliedBy(0.35)
        }
        
        onboardingTitleBackground.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide)
            make.bottom.equalTo(backgroundImage.snp.top)
            make.width.equalTo(onboardingTitleBackground.snp.height)
            make.centerX.equalTo(safeAreaLayoutGuide)
        }
        
        onboardingTitle.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        startButton.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(20)
            make.height.equalTo(44)
            make.bottom.equalTo(safeAreaLayoutGuide).inset(16)
        }
    }
}
