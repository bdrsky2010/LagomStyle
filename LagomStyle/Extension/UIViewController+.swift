//
//  UIViewController+.swift
//  LagomStyle
//
//  Created by Minjae Kim on 6/13/24.
//

import UIKit

// MARK: UIViewController extension Method: get identifier
extension UIViewController {
    
    static var identifier: String {
        return String(describing: self)
    }
}

extension UIViewController {
    
    func configureNavigationBackButton() {
        let lefttBarButtonItem = UIBarButtonItem(image: UIImage(systemName: LagomStyle.SystemImage.chevronLeft),
                                                 style: .plain,
                                                 target: self,
                                                 action: #selector(backButtonClicked))
        navigationItem.leftBarButtonItem = lefttBarButtonItem
    }
    
    @objc
    private func backButtonClicked() {
        navigationController?.popViewController(animated: true)
    }
}

extension UIViewController {
    func changeRootViewController(rootViewController: UIViewController) {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
        guard let window = (windowScene.delegate as? SceneDelegate)?.window else { return }
        
        let navigationController = UINavigationController(rootViewController: rootViewController)
        navigationController.navigationBar.tintColor = LagomStyle.Color.lagomBlack
        navigationController.configureNavigationBarTitleFont(font: LagomStyle.Font.bold16,
                                                             textColor: LagomStyle.Color.lagomBlack)
        
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
}
