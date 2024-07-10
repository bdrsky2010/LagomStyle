//
//  NVSBasketViewController.swift
//  LagomStyle
//
//  Created by Minjae Kim on 6/19/24.
//

import UIKit

import RealmSwift

// NVSProduct 타입과 Basket 타입을 연결해주는 공통 타입
struct CommonProduct {
    let title: String
    let mallName: String
    let lowPrice: String
    let imageUrlString: String
}

final class NVSBasketViewController: BaseViewController {
    
    private let nvsBasketView = NVSBasketView()
    private let realmRepository = RealmRepository()
    
    private var isTotalFolder: Bool {
        if let totalFolder = realmRepository.fetchItem(of: Folder.self).first, let folder {
            return totalFolder.id == folder.id
        } else {
            return false
        }
    }
    
    var onDeleteBasket: (() -> Void)?
    var folder: Folder?
    var totalBasketList: Results<Basket>!
    var folderBasketList = List<Basket>()
    
    override func loadView() {
        view = nvsBasketView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureData()
        configureCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        nvsBasketView.nvsBasketCollectionView.reloadData()
    }
    
    override func configureNavigation() {
        navigationItem.title = folder?.name
    }
    
    private func configureData() {
        if let folder {
            folderBasketList = folder.detail
        }
        totalBasketList = realmRepository.fetchItem(of: Basket.self)
    }
    
    private func configureCollectionView() {
        nvsBasketView.nvsBasketCollectionView.delegate = self
        nvsBasketView.nvsBasketCollectionView.dataSource = self
        nvsBasketView.nvsBasketCollectionView.register(SearchResultCollectionViewCell.self, forCellWithReuseIdentifier: SearchResultCollectionViewCell.identifier)
    }
}

extension NVSBasketViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let nvsProductDetailViewController = NVSProductDetailViewController()
        
        let index = indexPath.row
        if isTotalFolder {
            let product = totalBasketList[index]
            nvsProductDetailViewController.productID = product.id
            nvsProductDetailViewController.productTitle = product.name
            nvsProductDetailViewController.productLink = product.webUrlString
        } else {
            let product = folderBasketList[index]
            nvsProductDetailViewController.productID = product.id
            nvsProductDetailViewController.productTitle = product.name
            nvsProductDetailViewController.productLink = product.webUrlString
        }
        nvsProductDetailViewController.delegate = self
        nvsProductDetailViewController.row = index
        nvsProductDetailViewController.isBasket = true
        nvsProductDetailViewController.onChangeBasket = { [weak self] row, isBasket, _, _ in
            guard let self else { return }
            setLikeButtonImageToggle(row: row, isBasket: isBasket)
        }
        navigationController?.pushViewController(nvsProductDetailViewController, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isTotalFolder {
            return totalBasketList.count
        } else {
            return folderBasketList.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchResultCollectionViewCell.identifier, for: indexPath) as? SearchResultCollectionViewCell else { return UICollectionViewCell() }
        let index = indexPath.row
        cell.isBasket = true
        cell.row = indexPath.row
        cell.delegate = self
        
        if isTotalFolder {
            let product = totalBasketList[index]
            let commonProduct = CommonProduct(title: product.name, mallName: product.mallName, lowPrice: product.lowPrice, imageUrlString: product.imageUrlString)
            cell.configureContent(product: commonProduct)
        } else {
            let product = folderBasketList[index]
            let commonProduct = CommonProduct(title: product.name, mallName: product.mallName, lowPrice: product.lowPrice, imageUrlString: product.imageUrlString)
            cell.configureContent(product: commonProduct)
        }
        return cell
    }
}

extension NVSBasketViewController: NVSSearchDelegate {
    func setLikeButtonImageToggle(row: Int, isBasket: Bool) {
        if isTotalFolder {
            let basket = totalBasketList[row]
            realmRepository.deleteItem(basket)
        } else {
            let basket = folderBasketList[row]
            realmRepository.deleteItem(basket)
        }
        configureData() // 데이터 다시 받아오기
        nvsBasketView.nvsBasketCollectionView.reloadData()
        onDeleteBasket?()
    }
}
