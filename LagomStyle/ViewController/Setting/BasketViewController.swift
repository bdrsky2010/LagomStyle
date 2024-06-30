//
//  BasketViewController.swift
//  LagomStyle
//
//  Created by Minjae Kim on 6/19/24.
//

import UIKit

final class BasketViewController: BaseViewController {
    
    private let toggleContentView: UIView = {
        let view = UIView()
        view.layer.borderColor = LagomStyle.Color.lagomBlack.cgColor
        view.layer.borderWidth = 1
        return view
    }()
    
    private let productsCollectionView = ProductsCollectionView()
    private let productsTableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configureView() {
        configureCollectionView()
        configureTableView()
    }
    
    override func configureNavigation() {
        navigationItem.title = LagomStyle.phrase.basketViewNavigationTitle
    }
    
    private func configureCollectionView() {
        
    }
    
    private func configureTableView() {
        
    }
}
