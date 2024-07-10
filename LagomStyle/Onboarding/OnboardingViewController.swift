//
//  OnboardingViewController.swift
//  LagomStyle
//
//  Created by Minjae Kim on 6/16/24.
//

import UIKit

final class OnboardingViewController: BaseViewController {
    
    private let onboardingView = OnboardingView()
    
    override func loadView() {
        view = onboardingView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        configureNavigation()
    }
    
    override func configureView() {
        super.configureView()
    }
    
    override func configureNavigation() {
        navigationController?.navigationBar.isHidden = true
    }
    
    private func configureButton() {
        onboardingView.startButton.addTarget(self, action: #selector(startButtonClicked), for: .touchUpInside)
    }
    
    @objc
    private func startButtonClicked() {
        let profileSetupViewController = ProfileSetupViewController()
        profileSetupViewController.pfSetupType = .setup
        
        navigationController?.pushViewController(profileSetupViewController, animated: true)
    }
}
