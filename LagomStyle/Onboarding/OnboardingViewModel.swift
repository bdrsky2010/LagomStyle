//
//  OnboardingViewModel.swift
//  LagomStyle
//
//  Created by Minjae Kim on 7/10/24.
//

import Foundation

final class OnboardingViewModel {
    var inputViewDidLoad: Observable<Void?> = Observable(nil)
    var inputViewWillAppear: Observable<Void?> = Observable(nil)
    var inputStartButtonTrigger: Observable<Void?> = Observable(nil)
    
    private(set) var outputDidConfigureView: Observable<Void?> = Observable(nil)
    private(set) var outputDidConfigureNavigation: Observable<Void?> = Observable(nil)
    private(set) var outputDidSendPfSetupOption: Observable<LagomStyle.PFSetupOption?> = Observable(nil)
    
    init() {
        inputViewDidLoad.bind { [weak self] _ in
            guard let self else { return }
            outputDidConfigureView.value = ()
        }
        
        inputViewWillAppear.bind { [weak self] _ in
            guard let self else { return }
            outputDidConfigureNavigation.value = ()
        }
        
        inputStartButtonTrigger.bind { [weak self] _ in
            guard let self else { return }
            outputDidSendPfSetupOption.value = .setup
        }
    }
}
