//
//  MainViewController.swift
//  LagomStyle
//
//  Created by Minjae Kim on 6/16/24.
//

import UIKit

final class NVSSearchViewController: UIViewController, ConfigureViewProtocol {
    
    override func viewDidLoad() {
        
        configureView()
    }
    
    private func configureView() {
        view.backgroundColor = LagomStyle.Color.lagomWhite
        
        configureNavigation()
    }
    
    func configureNavigation() {
        guard let nickname = UserDefaultsHelper.getUserDefaults(forKey: LagomStyle.UserDefaultsKey.nickname) as? String else { return }
        navigationItem.title = nickname + LagomStyle.phrase.searchViewNavigationTitle
    }
}
