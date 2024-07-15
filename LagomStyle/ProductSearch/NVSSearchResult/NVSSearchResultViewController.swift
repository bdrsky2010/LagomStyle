//
//  NVSSearchResultViewController.swift
//  LagomStyle
//
//  Created by Minjae Kim on 6/16/24.
//

import UIKit

import Kingfisher
import RealmSwift
import SkeletonView
import SnapKit

final class NVSSearchResultViewController: BaseViewController {
    
    private let nvsSearchResultView: NVSSearchResultView
    private let viewModel: NVSSearchResultViewModel
    
    init(query: String) {
        self.nvsSearchResultView = NVSSearchResultView()
        self.viewModel = NVSSearchResultViewModel()
        super.init()
        bindData()
        viewModel.inputReceiveQueryString.value = query
    }
    
    override func loadView() {
        view = nvsSearchResultView
    }
    
    private func bindData() {
        viewModel.outputDidSetNavigationTitle.bind { [weak self] title in
            guard let self else { return }
            navigationItem.title = title
            configureNavigationBackButton()
        }
        
        viewModel.outputDidConfigureView.bind { [weak self] _ in
            guard let self else { return }
            viewModel.inputRequestAPI.value = ()
            
            configureCollectionView()
            nvsSearchResultView.searchResultCollectionView.showGradientSkeleton()
            configureFilteringButton()
        }
        
        viewModel.outputDidRequestAPI.bind { [weak self] _ in
            guard let self else { return }
            requestNVSSearchAPI()
        }
        
        viewModel.outputDidSendSearchResultCount.bind { [weak self] count in
            guard let self else { return }
            nvsSearchResultView.searchResultCountLabel.text = count.formatted() + LagomStyle.Phrase.searchResultCount
            // 검색 결과 없으면 콜렉션뷰 숨김
            if count == 0 {
                nvsSearchResultView.searchResultCollectionView.isHidden = true
                nvsSearchResultView.emptyView.isHidden = false
            } else {
                nvsSearchResultView.searchResultCollectionView.isHidden = false
                nvsSearchResultView.emptyView.isHidden = true
            }
        }
        
        viewModel.outputDidStopSkeletonAnimation.bind { [weak self] _ in
            guard let self else { return }
            nvsSearchResultView.searchResultCollectionView.stopSkeletonAnimation()
            nvsSearchResultView.searchResultCollectionView.hideSkeleton(reloadDataAfter: true, transition: .crossDissolve(0.25))
        }
        
        viewModel.outputDidTableViewReloadData.bind { [weak self] _ in
            guard let self else { return }
            nvsSearchResultView.searchResultCollectionView.reloadData()
        }
        
        viewModel.outputDidFailureAPIRequest.bind { [weak self] _ in
            guard let self else { return }
            nvsSearchResultView.searchResultCollectionView.isHidden = true
            nvsSearchResultView.emptyView.isHidden = false
        }
        
        viewModel.outputDidPushNavigation.bind { [weak self] tuple in
            guard let self, let tuple else { return }
            
            let nvsProductDetailViewController = NVSProductDetailViewController(row: tuple.index, product: CommonProduct(contentsOf: tuple.product))
            nvsProductDetailViewController.onChangeBasket = { [weak self] row, isBasket, oldFolder, newFolder in
                guard let self else { return }
                viewModel.inputOnChangeBasket.value = (row, isBasket, oldFolder, newFolder)
                nvsSearchResultView.searchResultCollectionView.reloadItems(at: [IndexPath(row: row, section: 0)])
            }
            
            navigationController?.pushViewController(nvsProductDetailViewController, animated: true)
        }
        
        viewModel.outputDidReconfigureBasketContent.bind { [weak self] tuple in
            guard let self, let tuple else { return }
            guard let cell = nvsSearchResultView.searchResultCollectionView.cellForItem(at: IndexPath(row: tuple.row, section: 0)) as? SearchResultCollectionViewCell else { return }
            
            if let oldFolder = tuple.oldFolder {
                cell.configureBasketContent(isBasket: oldFolder.id != tuple.newFolder.id)
            } else {
                cell.configureBasketContent(isBasket: true)
            }
        }
        
        viewModel.outputDidPresentFolderModal.bind { [weak self] tuple in
            guard let self, let tuple else { return }
            let addOrMoveBasketFolderViewController = AddOrMoveBasketFolderViewController(productID: tuple.product.productID)
            addOrMoveBasketFolderViewController.onChangeFolder = { [weak self] newFolder in
                guard let self else { return }
                viewModel.inputOnChangeFolder.value = (newFolder, tuple.index)
            }
            let navigationController = UINavigationController(rootViewController: addOrMoveBasketFolderViewController)
            present(navigationController, animated: true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.inputViewDidLoadTrigger.value = ()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        nvsSearchResultView.searchResultCollectionView.reloadData()
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
        nvsSearchResultView.filteringButtonList.forEach {
            $0.isUserInteractionEnabled = true

            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(filteringButtonClicked))
            $0.addGestureRecognizer(tapGesture)
        }
    }
    
    @objc
    private func filteringButtonClicked(sender: UITapGestureRecognizer) {
        guard let filteringButton = sender.view as? CapsuleTapActionButton else { return }
        
        // 컬렉션뷰 숨겨져 있으면 위로 스크롤 X
        if !nvsSearchResultView.searchResultCollectionView.isHidden {
            nvsSearchResultView.searchResultCollectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
        }
        
        guard viewModel.inputSelectedButtonTag.value != filteringButton.tag else { return }
        
        // UI처리
        nvsSearchResultView.searchResultCollectionView.showGradientSkeleton()
        nvsSearchResultView.filteringButtonList[viewModel.inputSelectedButtonTag.value].unSelectUI()
        filteringButton.selectUI()
        
        // 데이터 처리
        viewModel.inputSelectedButtonTag.value = filteringButton.tag
        viewModel.inputNVSSResult.value = nil
        viewModel.inputNVSSStartNumber.value = 1
        viewModel.inputRequestAPI.value = ()
    }
}

extension NVSSearchResultViewController: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        viewModel.inputAPIRequestNextPage.value = indexPaths
    }
}

extension NVSSearchResultViewController: SkeletonCollectionViewDelegate,
                                         SkeletonCollectionViewDataSource {
    func collectionSkeletonView(_ skeletonView: UICollectionView, cellIdentifierForItemAt indexPath: IndexPath) -> SkeletonView.ReusableCellIdentifier {
        return SearchResultCollectionViewCell.identifier
    }
    
    func collectionSkeletonView(_ skeletonView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.searchDisplayCount
    }
}

extension NVSSearchResultViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let index = indexPath.row
        guard let product = viewModel.inputNVSSResult.value?.products[index] else { return }
        viewModel.inputDidTapProduct.value = (product, index)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.inputNVSSResult.value?.products.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchResultCollectionViewCell.identifier, for: indexPath) as? SearchResultCollectionViewCell else { return UICollectionViewCell() }
        let index = indexPath.row
        
        guard let product = viewModel.inputNVSSResult.value?.products[index] else { return cell }
        
        let isBasket = viewModel.isProductExistOnBasket(product)
        let commonProduct = CommonProduct(contentsOf: product)
        
        cell.configureContent(product: commonProduct, isBasket: isBasket)
        cell.highlightingWithQuery(query: viewModel.inputReceiveQueryString.value)
        
        let basketButtonTapGesture = UITapGestureRecognizer(target: self, action: #selector(basketButtonTapped))
        cell.basketForegroundButtonView.tag = index
        cell.basketForegroundButtonView.isUserInteractionEnabled = true
        cell.basketForegroundButtonView.addGestureRecognizer(basketButtonTapGesture)
        
        return cell
    }
    
    @objc
    private func basketButtonTapped(sender: UITapGestureRecognizer) {
        guard let row = sender.view?.tag else { return }
        viewModel.inputDidTapBasketButton.value = row
    }
}

extension NVSSearchResultViewController {
    private func requestNVSSearchAPI() {
        NetworkHelper.shared.requestAPIWithAlertOnViewController(api: .naverShopping(viewModel.inputReceiveQueryString.value,
                                                                                     viewModel.searchDisplayCount,
                                                                                     viewModel.inputNVSSStartNumber.value,
                                                                                     viewModel.inputNVSSSortTypeList.value[viewModel.inputSelectedButtonTag.value].parameter),
                                                                 of: NVSSearch.self,
                                                                 viewController: self) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let value):
                viewModel.inputAPIRequestResult.value = value
            case .failure:
                viewModel.inputAPIRequestFailure.value = ()
            }
        }
    }
}
