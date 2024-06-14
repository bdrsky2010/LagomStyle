//
//  UINavigationController+.swift
//  LagomStyle
//
//  Created by Minjae Kim on 6/13/24.
//

import UIKit

extension UINavigationController: UIGestureRecognizerDelegate {
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = self
    }

    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return viewControllers.count > 1
    }
    
    // MARK: Root View를 바꿔주는 메서드
    func changeRootViewController(_ rootViewController: UIViewController) {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
        guard let window = (windowScene.delegate as? SceneDelegate)?.window else { return }
        
        let navigationController = UINavigationController(rootViewController: rootViewController)
        
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
    
    // MARK: NavigationBar의 Title의 Font와 Color 변경 메서드
    func configureNavigationBarTitleFont(font: UIFont, textColor: UIColor) {
        let navigationBarAppearance = UINavigationBarAppearance()
        
        navigationBarAppearance.titleTextAttributes = [
            NSAttributedString.Key.font: font,
            NSAttributedString.Key.foregroundColor: textColor
        ]
        
        navigationBar.standardAppearance = navigationBarAppearance
    }
}
