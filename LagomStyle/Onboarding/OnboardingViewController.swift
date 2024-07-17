//
//  OnboardingViewController.swift
//  LagomStyle
//
//  Created by Minjae Kim on 6/16/24.
//

import UIKit

final class OnboardingViewController: BaseViewController {
    
    private let onboardingView: OnboardingView
    private let viewModel: OnboardingViewModel
    
    override init() {
        self.onboardingView = OnboardingView()
        self.viewModel = OnboardingViewModel()
        super.init()
    }
    
    override func loadView() {
        view = onboardingView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindData()
        viewModel.inputViewDidLoad.value = ()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.inputViewWillAppear.value = ()
    }
    
    private func bindData() {
        viewModel.outputDidConfigureView.bind { [weak self] _ in
            guard let self else { return }
            configureButton()
        }
        
        viewModel.outputDidConfigureNavigation.bind { [weak self] _ in
            guard let self else { return }
            navigationController?.navigationBar.isHidden = true
        }
        
        viewModel.outputDidSendPfSetupOption.bind { [weak self] option in
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
        viewModel.inputStartButtonTrigger.value = ()
    }
}
