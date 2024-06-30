//
//  UIViewController+.swift
//  LagomStyle
//
//  Created by Minjae Kim on 6/13/24.
//

import UIKit

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
        if let _ = rootViewController as? UITabBarController {
            window.rootViewController = rootViewController
        } else {
            let navigationController = UINavigationController(rootViewController: rootViewController)
            navigationController.navigationBar.tintColor = LagomStyle.Color.lagomBlack
            navigationController.configureNavigationBarTitleFont(font: LagomStyle.Font.bold16,
                                                                 textColor: LagomStyle.Color.lagomBlack)
            
            window.rootViewController = navigationController
        }
        
        window.makeKeyAndVisible()
    }
}

extension UIViewController {
    enum AlertType {
        case oneButton
        case twoButton
    }
    
    func presentAlert(option alertType: AlertType,
                      title: String,
                      message: String? = nil,
                      checkAlertTitle: String,
                      completionHandler: ((UIAlertAction) -> Void)? = nil) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        switch alertType {
        case .oneButton:
            let check = UIAlertAction(title: checkAlertTitle, style: .default)
            alert.addAction(check)
        case .twoButton:
            let cancel = UIAlertAction(title: "취소", style: .cancel)
            let check = UIAlertAction(title: checkAlertTitle, style: .default, handler: completionHandler)
            alert.addAction(cancel)
            alert.addAction(check)
        }
        
        present(alert, animated: true)
    }
    
    func presentNetworkErrorAlert(error: NetworkError) {
        let title = error.alertTitle
        let message = error.alertMessage
        
        presentAlert(option: .oneButton, title: title, message: message, checkAlertTitle: "확인")
    }
}
