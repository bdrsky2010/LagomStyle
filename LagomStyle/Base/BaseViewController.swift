//
//  BaseViewController.swift
//  LagomStyle
//
//  Created by Minjae Kim on 6/25/24.
//

import UIKit

class BaseViewController: UIViewController {
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigation()
        configureView()
    }
    
    func configureNavigation() { }
    func configureView() { }
}
