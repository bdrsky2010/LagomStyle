//
//  NVSBasketViewController.swift
//  LagomStyle
//
//  Created by Minjae Kim on 6/19/24.
//

import UIKit

import RealmSwift

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
    
    var folder: Folder?
    var totalBasketList: Results<Basket>!
    var folderBasketList = List<Basket>()
    var onChangeFolder: (() -> Void)?
    
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
        nvsProductDetailViewController.row = index
        nvsProductDetailViewController.isBasket = true
        nvsProductDetailViewController.onChangeBasket = { [weak self] row, isBasket, oldFolder, newFolder in
            guard let self else { return }
            saveBasketData(row: row, isBasket: isBasket, oldFolder: oldFolder, newFolder: newFolder)
            self.onChangeFolder?()
        }
        navigationController?.pushViewController(nvsProductDetailViewController, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return isTotalFolder ? totalBasketList.count : folderBasketList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchResultCollectionViewCell.identifier, for: indexPath) as? SearchResultCollectionViewCell else { return UICollectionViewCell() }
        let index = indexPath.row
        let basket = isTotalFolder ? totalBasketList[index] : folderBasketList[index]
        let commonProduct = CommonProduct(title: basket.name, mallName: basket.mallName, lowPrice: basket.lowPrice, imageUrlString: basket.imageUrlString)
        
        cell.configureContent(product: commonProduct, isBasket: true)
        
        let basketButtonTapGesture = UITapGestureRecognizer(target: self, action: #selector(basketButtonTapped))
        cell.basketForegroundButtonView.tag = index
        cell.basketForegroundButtonView.isUserInteractionEnabled = true
        cell.basketForegroundButtonView.addGestureRecognizer(basketButtonTapGesture)
        
        return cell
    }
    
    @objc
    private func basketButtonTapped(sender: UITapGestureRecognizer) {
        guard let row = sender.view?.tag else { return }
        let selectedBasket = isTotalFolder ? totalBasketList[row] : folderBasketList[row]
        
        let addOrMoveBasketFolderViewController = AddOrMoveBasketFolderViewController()
        addOrMoveBasketFolderViewController.productID = selectedBasket.id
        addOrMoveBasketFolderViewController.onChangeFolder = { [weak self] newFolder in
            guard let self else { return }
            var isBasket = false
            var oldFolder: Folder?
            let basketList = realmRepository.fetchItem(of: Basket.self)
            for basket in basketList {
                if basket.id == selectedBasket.id {
                    isBasket = true
                    oldFolder = basket.folder.first
                    break
                }
            }
            saveBasketData(row: row, isBasket: isBasket, oldFolder: oldFolder, newFolder: newFolder)
            self.onChangeFolder?()
        }
        let navigationController = UINavigationController(rootViewController: addOrMoveBasketFolderViewController)
        present(navigationController, animated: true)
    }
    
    private func saveBasketData(row: Int, isBasket: Bool, oldFolder: Folder?, newFolder: Folder) {
        // TODO: 여기 뷰는 어차피 장바구니에 담겨있는 데이터만 가져오기 때문에 담겨있는 상태인지에 대한 판단이 필요없음
        // TODO: 해당 조건에 대한 로직 지워줄 것
        defer {
            nvsBasketView.nvsBasketCollectionView.reloadData()
        }
        // 장바구니 데이터에 대한 object에 대해 삭제가 일어나면 해당 객체에 대한 접근이 안되기 때문에
        let oldBasket = isTotalFolder ? totalBasketList[row] : folderBasketList[row]
        // 새로 Basket 인스턴스 생성
        let newBasket = Basket(id: oldBasket.id,
                               name: oldBasket.name,
                               mallName: oldBasket.mallName,
                               lowPrice: oldBasket.lowPrice,
                               webUrlString: oldBasket.webUrlString,
                               imageUrlString: oldBasket.imageUrlString)
        // 1. 먼저 전체 장바구니에 담겨있는 상태인지?
        let basketList = realmRepository.fetchItem(of: Basket.self)
        if isBasket, let oldFolder {
            for basket in basketList {
                if basket.id == oldBasket.id {
                    realmRepository.deleteItem(basket)
                    break
                }
            }
            // 2. 담겨있다면 담겨있는 폴더와 같은 폴더를 받아왔는지?
            if oldFolder.id == newFolder.id {
                // 3. 같은 폴더를 받아왔다면 '전체 장바구니에서 해당 상품 삭제'
                return
            } else {
                // 4. 다른 폴더를 받아왔다면 '전체 장바구니에서 해당 상품 삭제' 후 받아온 폴더에 추가
                realmRepository.createItem(newBasket, folder: newFolder)
            }
        } else {
            // 5. 담겨있지않다면 받아온 폴더에 담아주기
            realmRepository.createItem(newBasket, folder: newFolder)
        }
    }
}
