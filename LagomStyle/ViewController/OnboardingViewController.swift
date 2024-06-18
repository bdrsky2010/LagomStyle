//
//  OnboardingViewController.swift
//  LagomStyle
//
//  Created by Minjae Kim on 6/16/24.
//

import UIKit

import SnapKit

final class OnboardingViewController: UIViewController, ConfigureViewProtocol {
    
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
    
    private lazy var startButton = PrimaryColorRoundedButton(title: LagomStyle.phrase.onBoardingStart) { [weak self] in
        guard let self else { return }
        
        let profileSetupViewController = ProfileSetupViewController()
        profileSetupViewController.pfSetupType = .setup
        
        navigationController?.pushViewController(profileSetupViewController, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        configureNavigation()
    }
    
    func configureView() {
        view.backgroundColor = LagomStyle.Color.lagomWhite
        
        configureHierarchy()
        configureLayout()
    }
    
    func configureNavigation() {
        navigationController?.navigationBar.isHidden = true
    }
    
    func configureHierarchy() {
        view.addSubview(onboardingTitleBackground)
        onboardingTitleBackground.addSubview(onboardingTitle)
        
        view.addSubview(backgroundImage)
        view.addSubview(startButton)
    }
    
    func configureLayout() {
        backgroundImage.snp.makeConstraints { make in
            make.center.equalTo(view.safeAreaLayoutGuide)
            make.width.height.equalTo(view.snp.height).multipliedBy(0.35)
        }
        
        onboardingTitleBackground.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalTo(backgroundImage.snp.top)
            make.width.equalTo(onboardingTitleBackground.snp.height)
            make.centerX.equalTo(view.safeAreaLayoutGuide)
        }
        
        onboardingTitle.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        startButton.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(44)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(16)
        }
    }
}
