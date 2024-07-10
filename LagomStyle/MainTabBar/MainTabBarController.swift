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
        
        tabBar.tintColor = LagomStyle.AssetColor.lagomPrimaryColor
        tabBar.unselectedItemTintColor = LagomStyle.AssetColor.lagomGray
        
        let searchViewController = NVSSearchViewController()
        let settingViewController = SettingViewController()
        
        let searchNavigationController = UINavigationController(rootViewController: searchViewController)
        let settingNavigationController = UINavigationController(rootViewController: settingViewController)
        
        searchNavigationController.navigationBar.tintColor = LagomStyle.AssetColor.lagomBlack
        searchNavigationController.configureNavigationBarTitleFont(font: LagomStyle.SystemFont.bold16,
                                                             textColor: LagomStyle.AssetColor.lagomBlack)
        settingNavigationController.navigationBar.tintColor = LagomStyle.AssetColor.lagomBlack
        settingNavigationController.configureNavigationBarTitleFont(font: LagomStyle.SystemFont.bold16,
                                                             textColor: LagomStyle.AssetColor.lagomBlack)
        
        searchNavigationController.tabBarItem = UITabBarItem(
            title: LagomStyle.Phrase.searchTabBarTitle,
            image: UIImage(systemName: LagomStyle.SystemImage.magnifyingglass),
            tag: 0)
        settingNavigationController.tabBarItem = UITabBarItem(
            title: LagomStyle.Phrase.settingTabBarTitle,
            image: UIImage(systemName: LagomStyle.SystemImage.person),
            tag: 0)
        
        setViewControllers([searchNavigationController, settingNavigationController], animated: true)
    }
}
