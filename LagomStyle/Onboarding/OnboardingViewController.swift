//
//  OnboardingViewController.swift
//  LagomStyle
//
//  Created by Minjae Kim on 6/16/24.
//

import UIKit

final class OnboardingViewController: BaseViewController {
    
    private let onboardingView: OnboardingView
    private let onboardingViewModel: OnboardingViewModel
    
    override init() {
        self.onboardingView = OnboardingView()
        self.onboardingViewModel = OnboardingViewModel()
        super.init()
    }
    
    override func loadView() {
        view = onboardingView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindData()
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
    
    private func bindData() {
        onboardingViewModel.outputProfileSetupOption.bind { [weak self] option in
            guard let self, let option else { return }
            let profileSetupViewController = ProfileSetupViewController(pfSetupOption: option)
            navigationController?.pushViewController(profileSetupViewController, animated: true)
        }
    }
    
    private func configureButton() {
        onboardingView.startButton.addTarget(self, action: #selector(startButtonClicked), for: .touchUpInside)
    }
    
    @objc
    private func startButtonClicked() {
        onboardingViewModel.inputStartButtonTrigger.value = ()
    }
}
