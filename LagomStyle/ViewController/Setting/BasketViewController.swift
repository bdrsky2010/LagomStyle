//
//  BasketViewController.swift
//  LagomStyle
//
//  Created by Minjae Kim on 6/19/24.
//

import UIKit

final class BasketViewController: UIViewController, ConfigureViewProtocol {
    
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
        configureView()
    }
    
    func configureView() {
        view.backgroundColor = LagomStyle.Color.lagomWhite
        configureNavigation()
        configureHierarchy()
        configureLayout()
        configureCollectionView()
        configureTableView()
    }
    
    func configureNavigation() {
        navigationItem.title = LagomStyle.phrase.basketViewNavigationTitle
    }
    
    func configureHierarchy() {
        
    }
    
    func configureLayout() {
        
    }
    
    private func configureCollectionView() {
        
    }
    
    private func configureTableView() {
        
    }
}
