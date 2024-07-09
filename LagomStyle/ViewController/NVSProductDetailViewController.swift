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
    
    var delegate: NVSSearchDelegate?
    var row: Int?
    var isLike: Bool?
    var productID: String?
    var productTitle: String?
    var productLink: String?
    var onChangeBasket: ((_ row: Int, _ isLike: Bool, _ folder: Folder) -> Void)?
    
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
        guard let productTitle, let isLike else { return }
        navigationItem.title = productTitle
        let likeBarButtonItem = UIBarButtonItem(image: UIImage(named: LagomStyle.AssetImage.like(selected: isLike).imageName)?.withRenderingMode(.alwaysOriginal),
                                                style: .plain,
                                                target: self,
                                                action: #selector(likeButtonClicked))
        navigationItem.rightBarButtonItem = likeBarButtonItem
    }
    
    @objc
    private func likeButtonClicked() {
        isLike?.toggle()
        guard let isLike, let row else { return }
        navigationItem.rightBarButtonItem?.image = UIImage(named: LagomStyle.AssetImage.like(selected: isLike).imageName)?.withRenderingMode(.alwaysOriginal)
//        delegate?.setLikeButtonImageToggle(row: row, isLike: isLike)
        let addOrMoveBasketFolderViewController = AddOrMoveBasketFolderViewController()
        addOrMoveBasketFolderViewController.onChangeFolder = { [weak self] folder in
            guard let self else { return }
            print(folder.name)
            onChangeBasket?(row, isLike, folder)
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
