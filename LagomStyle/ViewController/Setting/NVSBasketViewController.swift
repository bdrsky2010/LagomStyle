//
//  NVSBasketViewController.swift
//  LagomStyle
//
//  Created by Minjae Kim on 6/19/24.
//

import UIKit

final class NVSBasketViewController: BaseViewController {
    
    private let nvsBasketView = NVSBasketView()
    
    private var likeProductDictionary: [NVSProduct: None] {
        get {
            guard let dict = UserDefaultsHelper.likeProducts else { return [:] }
            return dict
        }
        set {
            UserDefaultsHelper.likeProducts = newValue
        }
    }
    
    private var likeProductArray: [NVSProduct] {
        return likeProductDictionary.map { $0.key }.sorted(by: { $0 < $1 })
    }
    
    override func loadView() {
        view = nvsBasketView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        nvsBasketView.nvsBasketCollectionView.reloadData()
    }
    
    override func configureView() {
        configureCollectionView()
    }
    
    override func configureNavigation() {
        navigationItem.title = LagomStyle.Phrase.basketViewNavigationTitle
    }
    
    private func configureCollectionView() {
        nvsBasketView.nvsBasketCollectionView.delegate = self
        nvsBasketView.nvsBasketCollectionView.dataSource = self
        nvsBasketView.nvsBasketCollectionView.register(SearchResultCollectionViewCell.self, forCellWithReuseIdentifier: SearchResultCollectionViewCell.identifier)
    }
}

extension NVSBasketViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let index = indexPath.row
        let product = likeProductArray[index]
        
        let nvsProductDetailViewController = NVSProductDetailViewController()
        
        if likeProductDictionary[product] != nil {
            nvsProductDetailViewController.isLike = true
        } else {
            nvsProductDetailViewController.isLike = false
        }
        nvsProductDetailViewController.delegate = self
        nvsProductDetailViewController.productTitle = product.title
        nvsProductDetailViewController.productLink = product.urlString
        nvsProductDetailViewController.row = index
        
        navigationController?.pushViewController(nvsProductDetailViewController, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return likeProductArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchResultCollectionViewCell.identifier, for: indexPath) as? SearchResultCollectionViewCell else { return UICollectionViewCell() }
        let index = indexPath.row
        let product = likeProductArray[index]
        
        cell.isLiske = true
        cell.row = indexPath.row
        cell.configureContent(product: product)
        cell.delegate = self
        
        return cell
    }
}

extension NVSBasketViewController: NVSSearchDelegate {
    
    func setLikeButtonImageToggle(row: Int, isLike: Bool) {
        let product = likeProductArray[row]
        likeProductDictionary[product] = isLike ? None() : nil
        nvsBasketView.nvsBasketCollectionView.reloadData()
    }
}
