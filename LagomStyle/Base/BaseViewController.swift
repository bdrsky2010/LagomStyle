//
//  BaseViewController.swift
//  LagomStyle
//
//  Created by Minjae Kim on 6/25/24.
//

import UIKit

class BaseViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigation()
        configureView()
    }
    
    func configureNavigation() { }
    func configureView() { }
}
