//
//  NVSProductDetailViewController.swift
//  LagomStyle
//
//  Created by Minjae Kim on 6/16/24.
//

import UIKit

import RealmSwift

final class NVSProductDetailViewController: BaseViewController {
    private let nvsProductDetailView = NVSProductDetailView()
    private let realmRepository = RealmRepository()
    
    var delegate: NVSSearchDelegate?
    var row: Int?
    var isLike: Bool?
    var productID: String?
    var productTitle: String?
    var productLink: String?
    var onChangeBasket: ((_ row: Int, _ isBasket: Bool, _ oldFolder: Folder?, _ newFolder: Folder) -> Void)?
    
    override func loadView() {
        view = nvsProductDetailView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
    override func configureView() {
        requestWebView()
    }
    
    override func configureNavigation() {
        guard let productTitle, let productID else { return }
        navigationItem.title = productTitle
        let isBasket = realmRepository.fetchItem(of: Basket.self).contains(where: { $0.id == productID })
        let likeBarButtonItem = UIBarButtonItem(image: UIImage(named: LagomStyle.AssetImage.like(selected: isBasket).imageName)?.withRenderingMode(.alwaysOriginal),
                                                style: .plain,
                                                target: self,
                                                action: #selector(likeButtonClicked))
        navigationItem.rightBarButtonItem = likeBarButtonItem
    }
    
    @objc
    private func likeButtonClicked() {
        guard let productID, let row else { return }
        let addOrMoveBasketFolderViewController = AddOrMoveBasketFolderViewController()
        addOrMoveBasketFolderViewController.productID = productID
        addOrMoveBasketFolderViewController.onChangeFolder = { [weak self] newFolder in
            guard let self else { return }
            var isBasket = false
            var oldFolder: Folder?
            let basketList = realmRepository.fetchItem(of: Basket.self)
            for basket in basketList {
                if basket.id == productID {
                    isBasket = true
                    oldFolder = basket.folder.first
                    break
                }
            }
            if let oldFolder {
                navigationItem.rightBarButtonItem?.image = UIImage(named: LagomStyle.AssetImage.like(selected: oldFolder.id != newFolder.id).imageName)?.withRenderingMode(.alwaysOriginal)
            } else {
                navigationItem.rightBarButtonItem?.image = UIImage(named: LagomStyle.AssetImage.like(selected: true).imageName)?.withRenderingMode(.alwaysOriginal)
            }
            onChangeBasket?(row, isBasket, oldFolder, newFolder)
        }
        let navigationController = UINavigationController(rootViewController: addOrMoveBasketFolderViewController)
        present(navigationController, animated: true)
    }
    
    private func requestWebView() {
        guard let productLink, let url = URL(string: productLink) else { return }
        let request = URLRequest(url: url)
        nvsProductDetailView.webView.load(request)
    }
}
