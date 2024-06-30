//
//  NVSProductDetailViewController.swift
//  LagomStyle
//
//  Created by Minjae Kim on 6/16/24.
//

import UIKit

final class NVSProductDetailViewController: BaseViewController {
    private let nvsProductDetailView = NVSProductDetailView()
    
    var delegate: NVSSearchDelegate?
    var row: Int?
    var isLike: Bool?
    var productTitle: String?
    var productLink: String?
    
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
        let likeBarButtonItem = UIBarButtonItem(image: UIImage(named: LagomStyle.Image.like(selected: isLike).imageName)?.withRenderingMode(.alwaysOriginal),
                                                style: .plain,
                                                target: self,
                                                action: #selector(likeButtonClicked))
        navigationItem.rightBarButtonItem = likeBarButtonItem
    }
    
    @objc
    private func likeButtonClicked() {
        isLike?.toggle()
        guard let isLike, let row else { return }
        navigationItem.rightBarButtonItem?.image = UIImage(named: LagomStyle.Image.like(selected: isLike).imageName)?.withRenderingMode(.alwaysOriginal)
        delegate?.setLikeButtonImageToggle(row: row, isLike: isLike)
    }
    
    private func requestWebView() {
        guard let productLink, let url = URL(string: productLink) else { return }
        let request = URLRequest(url: url)
        nvsProductDetailView.webView.load(request)
    }
}
