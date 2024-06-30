//
//  NVSSearchResultViewController.swift
//  LagomStyle
//
//  Created by Minjae Kim on 6/16/24.
//

import UIKit

import Alamofire
import Kingfisher
import SkeletonView
import SnapKit

final class NVSSearchResultViewController: BaseViewController {
    
    private let nvsSearchResultView = NVSSearchResultView()
    
    private let searchDisplayCount = 30
    private let nvsSortTypeList = NVSSSort.allCases
    
    private var selectedButtonTag = 0
    private var searchResult: NVSSearch?
    private var nvssStartNumber = 1
    private var nvssIsPagingEnd = false
    
    private var likeProductList: [NVSProduct] {
        get {
            guard let list = UserDefaultsHelper.likeProducts else { return [] }
            return list
        }
        set {
            guard !newValue.isEmpty else {
                UserDefaultsHelper.removeUserDefaults(forKey: LagomStyle.UserDefaultsKey.likeProducts)
                return
            }
            UserDefaultsHelper.likeProducts = newValue
        }
    }
    
    var query: String?
    
    override func loadView() {
        view = nvsSearchResultView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let query {
            requestNVSSearchAPI(query: query)
        }
        configureCollectionView()
        
        nvsSearchResultView.searchResultCollectionView.showGradientSkeleton()
        configureFilteringButton()
    }
    
    override func configureView() {
        nvsSearchResultView.emptyView.isHidden = true
    }
    
    override func configureNavigation() {
        navigationItem.title = query
        configureNavigationBackButton()
    }
    
    private func configureCollectionView() {
        nvsSearchResultView.searchResultCollectionView.delegate = self
        nvsSearchResultView.searchResultCollectionView.dataSource = self
        nvsSearchResultView.searchResultCollectionView.prefetchDataSource = self
        nvsSearchResultView.searchResultCollectionView.register(SearchResultCollectionViewCell.self,
                                                                forCellWithReuseIdentifier: SearchResultCollectionViewCell.identifier)
        nvsSearchResultView.searchResultCollectionView.isSkeletonable = true
    }
    
    private func configureFilteringButton() {
        nvsSearchResultView.accuracyFilteringButton.isUserInteractionEnabled = true
        nvsSearchResultView.dateFilteringButton.isUserInteractionEnabled = true
        nvsSearchResultView.priceAscFilteringButton.isUserInteractionEnabled = true
        nvsSearchResultView.priceDscFilteringButton.isUserInteractionEnabled = true
        
        let accuracyGesture = UITapGestureRecognizer(target: self, action: #selector(accuracyButtonClicked))
        let dateGesture = UITapGestureRecognizer(target: self, action: #selector(dateButtonClicked))
        let priceAscGesture = UITapGestureRecognizer(target: self, action: #selector(priceAscButtonClicked))
        let priceDscGesture = UITapGestureRecognizer(target: self, action: #selector(priceDscButtonClicked))
        
        nvsSearchResultView.accuracyFilteringButton.addGestureRecognizer(accuracyGesture)
        nvsSearchResultView.dateFilteringButton.addGestureRecognizer(dateGesture)
        nvsSearchResultView.priceAscFilteringButton.addGestureRecognizer(priceAscGesture)
        nvsSearchResultView.priceDscFilteringButton.addGestureRecognizer(priceDscGesture)
    }
    
    @objc
    private func accuracyButtonClicked(sender: UITapGestureRecognizer) {
        filteringButtonClicked(nvsSearchResultView.accuracyFilteringButton)
    }
    
    @objc
    private func dateButtonClicked(sender: UITapGestureRecognizer) {
        filteringButtonClicked(nvsSearchResultView.dateFilteringButton)
    }
    
    @objc
    private func priceAscButtonClicked(sender: UITapGestureRecognizer) {
        filteringButtonClicked(nvsSearchResultView.priceAscFilteringButton)
    }
    
    @objc
    private func priceDscButtonClicked(sender: UITapGestureRecognizer) {
        filteringButtonClicked(nvsSearchResultView.priceDscFilteringButton)
    }
    
    private func filteringButtonClicked(_ sender: CapsuleTapActionButton) {
        // 컬렉션뷰 숨겨져 있으면 위로 스크롤 X
        if !nvsSearchResultView.searchResultCollectionView.isHidden {
            nvsSearchResultView.searchResultCollectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
        }
        
        guard selectedButtonTag != sender.tag else { return }
        nvsSearchResultView.searchResultCollectionView.showGradientSkeleton()
        let filteringButtonList = [
            nvsSearchResultView.accuracyFilteringButton,
            nvsSearchResultView.dateFilteringButton,
            nvsSearchResultView.priceAscFilteringButton,
            nvsSearchResultView.priceDscFilteringButton
        ]
        filteringButtonList[selectedButtonTag].unSelectUI()
        sender.selectUI()
        selectedButtonTag = sender.tag
        searchResult = nil
        nvssStartNumber = 1
        
        if let query {
            requestNVSSearchAPI(query: query)
        }
    }
}

extension NVSSearchResultViewController: NVSSearchDelegate {
    
    func setLikeButtonImageToggle(row: Int, isLike: Bool) {
        guard let product = searchResult?.products[row] else { return }
        
        if isLike {
            var likeProducts = UserDefaultsHelper.likeProducts ?? []
            if !likeProducts.contains(product) {
                likeProducts.append(product)
                UserDefaultsHelper.likeProducts = likeProducts
            }
        } else {
            if var likeProducts = UserDefaultsHelper.likeProducts, likeProducts.contains(product) {
                for i in 0..<likeProducts.count {
                    if likeProducts[i] == product {
                        likeProducts.remove(at: i)
                        break
                    }
                }
                UserDefaultsHelper.likeProducts = likeProducts
            }
        }
        
        nvsSearchResultView.searchResultCollectionView.reloadItems(at: [IndexPath(row: row, section: 0)])
    }
}

extension NVSSearchResultViewController: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        guard let query, !nvssIsPagingEnd else { return }
        for indexPath in indexPaths {
            let row = indexPath.row
            if row == nvssStartNumber - 10 {
                requestNVSSearchAPI(query: query)
            }
        }
    }
}

extension NVSSearchResultViewController: SkeletonCollectionViewDelegate,
                                         SkeletonCollectionViewDataSource {
    func collectionSkeletonView(_ skeletonView: UICollectionView, cellIdentifierForItemAt indexPath: IndexPath) -> SkeletonView.ReusableCellIdentifier {
        return SearchResultCollectionViewCell.identifier
    }
    
    func collectionSkeletonView(_ skeletonView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 30
    }
}

extension NVSSearchResultViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let index = indexPath.row
        guard let product = searchResult?.products[index] else { return }
        
        let nvsProductDetailViewController = NVSProductDetailViewController()
        
        if let likeProducts = UserDefaultsHelper.likeProducts, likeProducts.contains(product) {
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
        return searchResult?.products.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchResultCollectionViewCell.identifier, for: indexPath) as? SearchResultCollectionViewCell else { return UICollectionViewCell() }
        let index = indexPath.row
        guard let product = searchResult?.products[index] else { return cell }
        
        if let likeProducts = UserDefaultsHelper.likeProducts, likeProducts.contains(product) {
            cell.isLiske = true
        } else {
            cell.isLiske = false
        }
        cell.configureContent(product: product)
        cell.highlightingWithQuery(query: query)
        cell.delegate = self
        cell.row = index
        
        return cell
    }
}

extension NVSSearchResultViewController {
    
    private func requestNVSSearchAPI(query: String) {
        
        NetworkHelper.shared.requestAPIWithAlertOnViewController(api: .naverShopping(query,
                                                                                     searchDisplayCount, nvssStartNumber,
                                                                                     nvsSortTypeList[selectedButtonTag].parameter),
                                                                 of: NVSSearch.self,
                                                                 viewController: self) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let value):
                var value = value
                value.products.indices.forEach { i in
                    let title = value.products[i].title.removeHtmlTag
                    value.products[i].title = title
                }
                nvsSearchResultView.searchResultCountLabel.text = value.total.formatted() + LagomStyle.phrase.searchResultCount
                
                guard value.total != 0 else { // 검색 결과 없으면 콜렉션뷰 숨김
                    nvsSearchResultView.searchResultCollectionView.isHidden = true
                    nvsSearchResultView.emptyView.isHidden = false
                    return
                }
                
                nvsSearchResultView.searchResultCollectionView.isHidden = false
                nvsSearchResultView.emptyView.isHidden = true
                if let result = searchResult {
                    if result.total <= result.products.count {
                        nvssIsPagingEnd = true
                    }
                    
                    if !nvssIsPagingEnd {
                        searchResult?.products.append(contentsOf: value.products)
                        nvssStartNumber += searchDisplayCount
                    }
                } else {
                    searchResult = value
                    nvssStartNumber += searchDisplayCount
                }
                nvsSearchResultView.searchResultCollectionView.reloadData()
                nvsSearchResultView.searchResultCollectionView.stopSkeletonAnimation()
                nvsSearchResultView.searchResultCollectionView.hideSkeleton(reloadDataAfter: true, transition: .crossDissolve(0.25))
                
            case .failure:
                nvsSearchResultView.searchResultCollectionView.isHidden = true
                nvsSearchResultView.emptyView.isHidden = false
            }
        }
    }
}
