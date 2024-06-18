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
    
    func presentAlert(type alertType: AlertType, title: String, message: String, completionHandler: (() -> Void)? = nil) {
        // 1. alert 창 구성
        let title = title
        let message = message
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        // 2. alert button 구성
        let confirm = UIAlertAction(title: "확인", style: .default) { _ in
            completionHandler?()
        }
        
        // 3. alert에 button 추가
        alert.addAction(confirm)
        
        if alertType == .twoButton {
            let cancel = UIAlertAction(title: "취소", style: .cancel)
            alert.addAction(cancel)
        }
        
        present(alert, animated: true)
    }
}
