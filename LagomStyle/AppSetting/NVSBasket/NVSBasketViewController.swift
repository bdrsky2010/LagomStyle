//
//  NVSBasketViewController.swift
//  LagomStyle
//
//  Created by Minjae Kim on 6/19/24.
//

import UIKit

import RealmSwift

final class NVSBasketViewController: BaseViewController {
    
    private let nvsBasketView: NVSBasketView
    private let viewModel: NVSBasketViewModel
    private let realmRepository: RealmRepository
    
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
    
    init(folder: Folder) {
        self.nvsBasketView = NVSBasketView()
        self.viewModel = NVSBasketViewModel()
        self.realmRepository = RealmRepository()
        super.init()
        bindData()
        viewModel.inputInitViewController.value = folder
    }
    
    private func bindData() {
        viewModel.outputDidConfigureNavigation.bind { [weak self] title in
            guard let self else { return }
            navigationItem.title = title
        }
        
        viewModel.outputDidConfigureView.bind { [weak self] _ in
            guard let self else { return }
            configureCollectionView()
        }
        
        viewModel.outputDidCollectionViewReloadData.bind { [weak self] _ in
            guard let self else { return }
            nvsBasketView.nvsBasketCollectionView.reloadData()
        }
        
        viewModel.outputDidPushNavigation.bind { [weak self] row in
            guard let self else { return }
            let product = viewModel.outputDidCheckIsTotalFolder.value ? viewModel.outputDidSetTotalBasketList.value[row] : viewModel.outputDidSetFolderBasketList.value[row]
            let nvsProductDetailViewController = NVSProductDetailViewController(row: row, product: CommonProduct(contentsOf: product))
            nvsProductDetailViewController.onChangeBasket = { [weak self] row, isBasket, oldFolder, newFolder in
                guard let self, let oldFolder else { return }
                viewModel.inputOnChangeBasket.value = (row, isBasket, oldFolder, newFolder)
                onChangeFolder?()
            }
            navigationController?.pushViewController(nvsProductDetailViewController, animated: true)
        }
        
        viewModel.outputDidPresentFolderModal.bind { [weak self] tuple in
            guard let self, let tuple else { return }
            
            let addOrMoveBasketFolderViewController = AddOrMoveBasketFolderViewController()
            addOrMoveBasketFolderViewController.productID = tuple.selectedBasket.id
            addOrMoveBasketFolderViewController.onChangeFolder = { [weak self] newFolder in
                guard let self else { return }
                viewModel.inputOnChangeFolder.value = (tuple.index, newFolder)
                onChangeFolder?()
            }
            let navigationController = UINavigationController(rootViewController: addOrMoveBasketFolderViewController)
            present(navigationController, animated: true)
        }
    }
    
    override func loadView() {
        view = nvsBasketView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.inputViewDidLoad.value = ()
        configureData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.inputCollectionViewReloadData.value = ()
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
        viewModel.inputDidSelectItemAt.value = indexPath.row
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if viewModel.outputDidCheckIsTotalFolder.value {
            return viewModel.outputDidSetTotalBasketList.value.count
        } else {
            return viewModel.outputDidSetFolderBasketList.value.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchResultCollectionViewCell.identifier, for: indexPath) as? SearchResultCollectionViewCell else { return UICollectionViewCell() }
        let index = indexPath.row
        let basket = viewModel.outputDidCheckIsTotalFolder.value ? viewModel.outputDidSetTotalBasketList.value[index] : viewModel.outputDidSetFolderBasketList.value[index]
        let commonProduct = CommonProduct(contentsOf: basket)
        
        cell.configureContent(product: commonProduct, isBasket: true)
        
        let basketButtonTapGesture = UITapGestureRecognizer(target: self, action: #selector(basketButtonTapped))
        cell.basketForegroundButtonView.tag = index
        cell.basketForegroundButtonView.isUserInteractionEnabled = true
        cell.basketForegroundButtonView.addGestureRecognizer(basketButtonTapGesture)
        
        return cell
    }
    
    @objc
    private func basketButtonTapped(sender: UITapGestureRecognizer) {
        guard let tag = sender.view?.tag else { return }
        viewModel.inputBasketButtonTapped.value = tag
    }
}
