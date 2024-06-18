//
//  BasketViewController.swift
//  LagomStyle
//
//  Created by Minjae Kim on 6/19/24.
//

import UIKit

final class BasketViewController: UIViewController, ConfigureViewProtocol {
    
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
