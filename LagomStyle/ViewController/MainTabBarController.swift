//
//  MainTabBarController.swift
//  LagomStyle
//
//  Created by Minjae Kim on 6/16/24.
//

import UIKit

final class MainTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBar.tintColor = LagomStyle.Color.lagomPrimaryColor
        tabBar.unselectedItemTintColor = LagomStyle.Color.lagomGray
        
        let searchViewController = NVSSearchViewController()
        let settingViewController = SettingViewController()
        
        let searchNavigationController = UINavigationController(rootViewController: searchViewController)
        let settingNavigationController = UINavigationController(rootViewController: settingViewController)
        
        searchNavigationController.tabBarItem = UITabBarItem(
            title: LagomStyle.phrase.searchTabBarTitle,
            image: UIImage(systemName: LagomStyle.SystemImage.magnifyingglass),
            tag: 0)
        settingNavigationController.tabBarItem = UITabBarItem(
            title: LagomStyle.phrase.settingTabBarTitle,
            image: UIImage(systemName: LagomStyle.SystemImage.person),
            tag: 0)
        
        setViewControllers([searchNavigationController, settingNavigationController], animated: true)
    }
}
