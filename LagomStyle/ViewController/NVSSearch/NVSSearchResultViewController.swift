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

final class NVSSearchResultViewController: UIViewController, ConfigureViewProtocol {
    
    private let searchResultCountLabel = UILabel.primaryBold13()
    
    private lazy var accuracyFilteringButton = CapsuleTapActionButton(title: NVSSSort.sim.segmentedTitle, tag: 0) { [weak self] sender in
        guard let self else { return }
        filteringButtonClicked(sender)
    }
    private lazy var dateFilteringButton = CapsuleTapActionButton(title: NVSSSort.date.segmentedTitle, tag: 1) { [weak self] sender in
        guard let self else { return }
        filteringButtonClicked(sender)
    }
    private lazy var priceAscFilteringButton = CapsuleTapActionButton(title: NVSSSort.dsc.segmentedTitle, tag: 2) { [weak self] sender in
        guard let self else { return }
        filteringButtonClicked(sender)
    }
    private lazy var priceDscFilteringButton = CapsuleTapActionButton(title: NVSSSort.asc.segmentedTitle, tag: 3) { [weak self] sender in
        guard let self else { return }
        filteringButtonClicked(sender)
    }
    
    private let searchResultCollectionView = ProductsCollectionView()
    private let emptyView = EmptyResultView(text: LagomStyle.phrase.searchEmptyResult)
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let query {
            requestNVSSearchAPI(query: query)
        }
        configureView()
    }
    
    func configureView() {
        view.backgroundColor = LagomStyle.Color.lagomWhite
        configureNavigation()
        configureHierarchy()
        configureLayout()
        configureCollectionView()
        emptyView.isHidden = true
        searchResultCollectionView.showGradientSkeleton()
    }
    
    func configureNavigation() {
        navigationItem.title = query
        configureNavigationBackButton()
    }
    
    func configureHierarchy() {
        view.addSubview(searchResultCountLabel)
        view.addSubview(accuracyFilteringButton)
        view.addSubview(dateFilteringButton)
        view.addSubview(priceAscFilteringButton)
        view.addSubview(priceDscFilteringButton)
        view.addSubview(searchResultCollectionView)
        view.addSubview(emptyView)
    }
    
    func configureLayout() {
        searchResultCountLabel.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide).offset(20)
        }
        
        accuracyFilteringButton.snp.makeConstraints { make in
            make.top.equalTo(searchResultCountLabel.snp.bottom).offset(16)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(20)
        }
        
        dateFilteringButton.snp.makeConstraints { make in
            make.leading.equalTo(accuracyFilteringButton.snp.trailing).offset(8)
            make.centerY.equalTo(accuracyFilteringButton)
        }
        
        priceAscFilteringButton.snp.makeConstraints { make in
            make.leading.equalTo(dateFilteringButton.snp.trailing).offset(8)
            make.centerY.equalTo(accuracyFilteringButton)
        }
        
        priceDscFilteringButton.snp.makeConstraints { make in
            make.leading.equalTo(priceAscFilteringButton.snp.trailing).offset(8)
            make.centerY.equalTo(accuracyFilteringButton)
        }
        
        searchResultCollectionView.snp.makeConstraints { make in
            make.top.equalTo(accuracyFilteringButton.snp.bottom).offset(16)
            make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        emptyView.snp.makeConstraints { make in
            make.top.equalTo(accuracyFilteringButton.snp.bottom)
            make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func configureCollectionView() {
        searchResultCollectionView.delegate = self
        searchResultCollectionView.dataSource = self
        searchResultCollectionView.prefetchDataSource = self
        searchResultCollectionView.register(SearchResultCollectionViewCell.self,
                                            forCellWithReuseIdentifier: SearchResultCollectionViewCell.identifier)
        searchResultCollectionView.isSkeletonable = true
    }
    
    private func filteringButtonClicked(_ sender: CapsuleTapActionButton) {
        
        // 컬렉션뷰 숨겨져 있으면 위로 스크롤 X
        if !searchResultCollectionView.isHidden {
            searchResultCollectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
        }
        
        guard selectedButtonTag != sender.tag else { return }
        searchResultCollectionView.showGradientSkeleton()
        let filteringButtonList = [
            accuracyFilteringButton, dateFilteringButton, priceAscFilteringButton, priceDscFilteringButton
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
        
        searchResultCollectionView.reloadItems(at: [IndexPath(row: row, section: 0)])
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
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
            guard let self else { return }
            
            let parameters: Parameters = [
                "query": query,
                "display": searchDisplayCount,
                "start": nvssStartNumber,
                "sort": nvsSortTypeList[selectedButtonTag].parameter
            ]
            let headers: HTTPHeaders = [
                "X-Naver-Client-Id": APIKey.naverClientID,
                "X-Naver-Client-Secret": APIKey.naverClientSecret
            ]
            
            NetworkHelper.requestAPI(urlString: APIUrl.naverShopping,
                                     method: .get,
                                     parameters: parameters,
                                     encoding: URLEncoding.queryString,
                                     headers: headers,
                                     of: NVSSearch.self
            ) { [weak self] value in
                guard let self else { return }
                
                var value = value
                value.products.indices.forEach { i in
                    let title = value.products[i].title.removeHtmlTag
                    value.products[i].title = title
                }
                searchResultCountLabel.text = value.total.formatted() + LagomStyle.phrase.searchResultCount
                
                guard value.total != 0 else { // 검색 결과 없으면 콜렉션뷰 숨김
                    searchResultCollectionView.isHidden = true
                    emptyView.isHidden = false
                    return
                }
                
                searchResultCollectionView.isHidden = false
                emptyView.isHidden = true
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
                searchResultCollectionView.reloadData()
                searchResultCollectionView.stopSkeletonAnimation()
                searchResultCollectionView.hideSkeleton(reloadDataAfter: true, transition: .crossDissolve(0.25))
                
            } failure: { [weak self] error in
                guard let self else { return }
                
                presentAlert(type: .oneButton,
                             title: LagomStyle.phrase.networkErrorTitle,
                             message: LagomStyle.phrase.networkErrorMessage)
                searchResultCollectionView.isHidden = true
                emptyView.isHidden = false
            }
        }
    }
}
