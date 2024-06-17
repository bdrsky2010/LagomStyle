//
//  NVSSearchResultViewController.swift
//  LagomStyle
//
//  Created by Minjae Kim on 6/16/24.
//

import UIKit

import Alamofire
import Kingfisher
import SnapKit

final class NVSSearchResultViewController: UIViewController, ConfigureViewProtocol {
    private let searchResultCountLabel: UILabel = {
        let label = UILabel()
        label.font = LagomStyle.Font.bold13
        label.textColor = LagomStyle.Color.lagomPrimaryColor
        return label
    }()
    
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
    
    private let searchResultCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let sectionSpacing: CGFloat = 16
        let cellSpacing: CGFloat = 16
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            let screenWidth = windowScene.screen.bounds.width
            let itemWidth = screenWidth - (sectionSpacing * 2) - cellSpacing
            layout.itemSize = CGSize(width: itemWidth / 2, height: itemWidth / 1.2)
            layout.minimumLineSpacing = sectionSpacing
            layout.minimumInteritemSpacing = cellSpacing
            layout.scrollDirection = .vertical
            layout.sectionInset = UIEdgeInsets(top: sectionSpacing, left: sectionSpacing, bottom: sectionSpacing, right: sectionSpacing)
        }
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return collectionView
    }()
    
    private let searchDisplayCount = 30
    private let nvsSortTypeList = NVSSSort.allCases
    
    // 0. 정확도 1. 날짜순 2. 가격높은순 3. 가격낮은순
    private var searchResultList = Array(repeating: NVSSearch(total: 0, start: 0, display: 0, items: []), count: 4)
    private var selectedButtonTag = 0
    private var nvssStartNumberList = [1, 1, 1, 1]
    private var nvssIsPagingEndList = [false, false, false, false]
    private var likeProductList: [NVSProduct] {
        get {
            guard let list = UserDefaultsHelper.likeProducts else { return [] }
            return list
        }
        set {
            guard !newValue.isEmpty else {
                UserDefaultsHelper.removeUsetDefaults(forKey: LagomStyle.UserDefaultsKey.likeProducts)
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
    
    private func configureView() {
        view.backgroundColor = LagomStyle.Color.lagomWhite
        configureNavigation()
        configureHierarchy()
        configureLayout()
        configureCollectionView()
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
    }
    
    private func configureCollectionView() {
        searchResultCollectionView.delegate = self
        searchResultCollectionView.dataSource = self
        searchResultCollectionView.prefetchDataSource = self
        searchResultCollectionView.register(SearchResultCollectionViewCell.self,
                                            forCellWithReuseIdentifier: SearchResultCollectionViewCell.identifier)
    }
    
    private func filteringButtonClicked(_ sender: CapsuleTapActionButton) {
        guard selectedButtonTag != sender.tag else { return }
        
        searchResultCollectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
        
        let filteringButtonList = [
            accuracyFilteringButton, dateFilteringButton, priceAscFilteringButton, priceDscFilteringButton
        ]
        filteringButtonList[selectedButtonTag].unSelectUI()
        sender.selectUI()
        selectedButtonTag = sender.tag
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            guard let self else { return }
            
            if let query {
                requestNVSSearchAPI(query: query)
            }
        }
    }
}

extension NVSSearchResultViewController: NVSSearchDelegate {
    
    func setLikeButtonImageToggle(row: Int, isLike: Bool) {
        let product = searchResultList[selectedButtonTag].items[row]
        
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
        guard let query, !nvssIsPagingEndList[selectedButtonTag] else { return }
        for indexPath in indexPaths {
            let row = indexPath.row
            print(row, nvssStartNumberList[selectedButtonTag])
            if row == nvssStartNumberList[selectedButtonTag] - 5 {
                requestNVSSearchAPI(query: query)
            }
        }
    }
}

extension NVSSearchResultViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let nvsProductDetailViewController = NVSProductDetailViewController()
        
        let index = indexPath.row
        let product = searchResultList[selectedButtonTag].items[index]
        
        if let likeProducts = UserDefaultsHelper.likeProducts, likeProducts.contains(product) {
            nvsProductDetailViewController.isLike = true
        } else {
            nvsProductDetailViewController.isLike = false
        }
        nvsProductDetailViewController.delegate = self
        nvsProductDetailViewController.productTitle = product.title
        nvsProductDetailViewController.productLink = product.link
        nvsProductDetailViewController.row = index
        
        navigationController?.pushViewController(nvsProductDetailViewController, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return searchResultList[selectedButtonTag].items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchResultCollectionViewCell.identifier, for: indexPath) as? SearchResultCollectionViewCell else { return UICollectionViewCell() }
        let index = indexPath.row
        let product = searchResultList[selectedButtonTag].items[index]
        
        if let likeProducts = UserDefaultsHelper.likeProducts, likeProducts.contains(product) {
            cell.isLiske = true
        } else {
            cell.isLiske = false
        }
        cell.configureContent(product: product)
        cell.delegate = self
        cell.row = index
        
        return cell
    }
}

extension NVSSearchResultViewController {
    
    private func requestNVSSearchAPI(query: String) {
        let parameters: Parameters = [
            "query": query,
            "display": searchDisplayCount,
            "start": nvssStartNumberList[selectedButtonTag],
            "sort": nvsSortTypeList[selectedButtonTag].parameter
        ]
        let headers: HTTPHeaders = [
            "X-Naver-Client-Id": APIKey.naverClientID,
            "X-Naver-Client-Secret": APIKey.naverClientSecret
        ]
        
        AF.request(APIUrl.naverShopping,
                   method: .get,
                   parameters: parameters,
                   encoding: URLEncoding.queryString,
                   headers: headers)
        .responseDecodable(of: NVSSearch.self) { [weak self] response in
            guard let self else { return }
            
            switch response.result {
            case .success(let value):
                var value = value
                value.items.indices.forEach { i in
                    let title = value.items[i].title.removeHtmlTag
                    value.items[i].title = title
                }
                searchResultCountLabel.text = value.total.formatted() + LagomStyle.phrase.searchResultCount
                
                if searchResultList[selectedButtonTag].total <= searchResultList[selectedButtonTag].items.count {
                    nvssIsPagingEndList[selectedButtonTag] = false
                }
                
                if searchResultList[selectedButtonTag].items.isEmpty {
                    searchResultList[selectedButtonTag] = value
                    nvssStartNumberList[selectedButtonTag] += searchDisplayCount
                } else if !nvssIsPagingEndList[selectedButtonTag] {
                    searchResultList[selectedButtonTag].items.append(contentsOf: value.items)
                    nvssStartNumberList[selectedButtonTag] += searchDisplayCount
                }
                searchResultCollectionView.reloadData()
            case .failure(let error):
                print(error)
            }
        }
    }
}
