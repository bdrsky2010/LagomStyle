//
//  OnboardingViewModel.swift
//  LagomStyle
//
//  Created by Minjae Kim on 7/10/24.
//

import Foundation

final class OnboardingViewModel {
    var inputStartButtonTrigger: Observable<Void?> = Observable(nil)
    
    private(set) var outputProfileSetupOption: Observable<LagomStyle.PFSetupOption?> = Observable(nil)
    
    init() {
        inputStartButtonTrigger.bind { [weak self] _ in
            guard let self else { return }
            outputProfileSetupOption.value = .setup
        }
    }
}
