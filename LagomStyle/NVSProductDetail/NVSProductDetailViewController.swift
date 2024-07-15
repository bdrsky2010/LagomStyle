//
//  NVSProductDetailViewController.swift
//  LagomStyle
//
//  Created by Minjae Kim on 6/16/24.
//

import UIKit

import RealmSwift

final class NVSProductDetailViewController: BaseViewController {
    private let nvsProductDetailView: NVSProductDetailView
    private let viewModel: NVSProductDetailViewModel
    
    var onChangeBasket: ((_ row: Int, _ isBasket: Bool, _ oldFolder: Folder?, _ newFolder: Folder) -> Void)?
    
    init(row: Int, product: CommonProduct) {
        self.nvsProductDetailView = NVSProductDetailView()
        self.viewModel = NVSProductDetailViewModel()
        super.init()
        bindData()
        viewModel.inputInitRow.value = row
        viewModel.inputInitProduct.value = product
    }
    
    private func bindData() {
        viewModel.outputDidConfigureNavigation.bind { [weak self] tuple in
            guard let self ,let tuple else { return }
            navigationItem.title = tuple.title
            let likeBarButtonItem = UIBarButtonItem(image: UIImage(named: tuple.image)?.withRenderingMode(.alwaysOriginal),
                                                    style: .plain,
                                                    target: self,
                                                    action: #selector(basketButtonClicked))
            navigationItem.rightBarButtonItem = likeBarButtonItem
        }
        
        viewModel.outputDidRequestWebView.bind { [weak self] request in
            guard let self, let request else { return }
            nvsProductDetailView.webView.load(request)
        }
        
        viewModel.outputDidPresentAddOrMoveBasketFolderView.bind { [weak self] tuple in
            guard let self, let tuple else { return }
            let addOrMoveBasketFolderViewController = AddOrMoveBasketFolderViewController()
            addOrMoveBasketFolderViewController.productID = tuple.id
            addOrMoveBasketFolderViewController.onChangeFolder = { [weak self] newFolder in
                guard let self else { return }
                var oldFolder: Folder?
                let isBasket = viewModel.isProductExistBasket(tuple.id) { folder in
                    oldFolder = folder
                }
                viewModel.inputOnChangeFolder.value = (oldFolder, newFolder)
                onChangeBasket?(tuple.row, isBasket, oldFolder, newFolder)
            }
            let navigationController = UINavigationController(rootViewController: addOrMoveBasketFolderViewController)
            present(navigationController, animated: true)
        }
        
        viewModel.outputDidReconfigureNavigation.bind { [weak self] image in
            guard let self else { return }
            navigationItem.rightBarButtonItem?.image = UIImage(named: image)?.withRenderingMode(.alwaysOriginal)
        }
    }
    
    override func loadView() {
        view = nvsProductDetailView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.inputViewDidLoad.value = ()
    }
    
    @objc
    private func basketButtonClicked() {
        viewModel.inputBasketButtonClicked.value = ()
    }
}
