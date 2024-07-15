//
//  NVSSearchResultViewModel.swift
//  LagomStyle
//
//  Created by Minjae Kim on 7/13/24.
//

import Foundation

final class NVSSearchResultViewModel {
    private let realmRepository: RealmRepository
    
    let searchDisplayCount = 30
    
    var inputReceiveQueryString: Observable<String> = Observable("")
    var inputViewDidLoadTrigger: Observable<Void?> = Observable(nil)
    
    var inputRequestAPI: Observable<Void?> = Observable(nil)
    var inputNVSSSortTypeList: Observable<[NVSSSort]> = Observable(NVSSSort.allCases)
    var inputSelectedButtonTag: Observable<Int> = Observable(0)
    var inputNVSSStartNumber: Observable<Int> = Observable(1)
    var inputNVSSIsEnabledPaging: Observable<Bool> = Observable(true)
    var inputNVSSResult: Observable<NVSSearch?> = Observable(nil)
    var inputAPIRequestResult: Observable<NVSSearch?> = Observable(nil)
    var inputAPIRequestFailure: Observable<Void?> = Observable(nil)
    var inputAPIRequestNextPage: Observable<[IndexPath]> = Observable([])
    var inputDidTapProduct: Observable<(product: NVSProduct, index: Int)?> = Observable(nil)
    var inputOnChangeBasket: Observable<(row: Int, isBasket: Bool, oldFolder: Folder?, newFolder: Folder)?> = Observable(nil)
    var inputDidTapBasketButton: Observable<Int> = Observable(0)
    var inputOnChangeFolder: Observable<(newFolder: Folder, row: Int)?> = Observable(nil)
    
    private(set) var outputDidSetNavigationTitle: Observable<String> = Observable("")
    private(set) var outputDidConfigureView: Observable<Void?> = Observable(nil)
    private(set) var outputDidRequestAPI: Observable<Void?> = Observable(nil)
    private(set) var outputDidSendSearchResultCount: Observable<Int> = Observable(0)
    private(set) var outputDidStopSkeletonAnimation: Observable<Void?> = Observable(nil)
    private(set) var outputDidTableViewReloadData: Observable<Void?> = Observable(nil)
    private(set) var outputDidFailureAPIRequest: Observable<Void?> = Observable(nil)
    private(set) var outputDidPushNavigation: Observable<(product: NVSProduct, index: Int)?> = Observable(nil)
    private(set) var outputDidPresentFolderModal: Observable<(product: NVSProduct, index: Int)?> = Observable(nil)
    private(set) var outputDidReconfigureBasketContent: Observable<(row: Int, oldFolder: Folder?, newFolder: Folder)?> = Observable(nil)
    
    init() {
        self.realmRepository = RealmRepository()
        bindData()
    }
    
    private func bindData() {
        inputViewDidLoadTrigger.bind { [weak self] _ in
            guard let self else { return }
            outputDidConfigureView.value = ()
        }
        
        inputReceiveQueryString.bind { [weak self] query in
            guard let self else { return }
            outputDidSetNavigationTitle.value = query
        }
        
        inputRequestAPI.bind { [weak self] _ in
            guard let self else { return }
            outputDidRequestAPI.value = ()
        }
        
        inputAPIRequestResult.bind { [weak self] result in
            guard let self, var result else { return }
            outputDidSendSearchResultCount.value = result.total
            
            result.products.indices.forEach { i in
                let title = result.products[i].title.removeHtmlTag
                result.products[i].title = title
            }
            // 검색결과 데이터가 프로퍼티에 존재하는지
            if let searchResult = inputNVSSResult.value {
                if result.total <= searchResult.products.count {
                    inputNVSSIsEnabledPaging.value = false
                } else {
                    inputNVSSIsEnabledPaging.value = true
                }
                
                if inputNVSSIsEnabledPaging.value {
                    inputNVSSResult.value?.products.append(contentsOf: result.products)
                    inputNVSSStartNumber.value += searchDisplayCount
                }
            } else { // 검색결과 데이터가 프로퍼티에 존재하지 않는지
                inputNVSSResult.value = result
                inputNVSSStartNumber.value += searchDisplayCount
            }
            outputDidStopSkeletonAnimation.value = ()
            outputDidTableViewReloadData.value = ()
        }
        
        inputAPIRequestFailure.bind { [weak self] _ in
            guard let self else { return }
            outputDidFailureAPIRequest.value = ()
        }
        
        inputAPIRequestNextPage.bind { [weak self] indexPaths in
            guard let self, inputNVSSIsEnabledPaging.value else { return }
            for indexPath in indexPaths {
                let row = indexPath.row
                if row == inputNVSSStartNumber.value - 10 {
                    inputRequestAPI.value = ()
                }
            }
        }
        
        inputDidTapProduct.bind { [weak self] tuple in
            guard let self else { return }
            outputDidPushNavigation.value = tuple
        }
        
        inputOnChangeBasket.bind { [weak self] tuple in
            guard let self, let tuple else { return }
            saveBasketData(row: tuple.row, isBasket: tuple.isBasket, oldFolder: tuple.oldFolder, newFolder: tuple.newFolder)
        }
        
        inputDidTapBasketButton.bind { [weak self] tag in
            guard let self, let product = inputNVSSResult.value?.products[tag] else { return }
            outputDidPresentFolderModal.value = (product, tag)
        }
        
        inputOnChangeFolder.bind { [weak self] tuple in
            guard let self, let tuple, let product = inputNVSSResult.value?.products[tuple.row] else { return }
            var oldFolder: Folder?
            let isBasket = isProductExistOnBasket(product) { folder in
                oldFolder = folder
            }
            saveBasketData(row: tuple.row, isBasket: isBasket, oldFolder: oldFolder, newFolder: tuple.newFolder)
            outputDidReconfigureBasketContent.value = (tuple.row, oldFolder, tuple.newFolder)
        }
    }
    
    func isProductExistOnBasket(_ product: NVSProduct, completionHandler: ((Folder?) -> Void)? = nil) -> Bool {
        let basketList = realmRepository.fetchItem(of: Basket.self)
        var isBasket = false
        for basket in basketList {
            if basket.id == product.productID {
                isBasket = true
                completionHandler?(basket.folder.first)
                break
            }
        }
        return isBasket
    }
    
    private func saveBasketData(row: Int, isBasket: Bool, oldFolder: Folder?, newFolder: Folder) {
        guard let product = inputNVSSResult.value?.products[row] else { return }
        let newBasket = Basket(id: product.productID,
                            name: product.title,
                            mallName: product.mallName,
                            lowPrice: product.lowPrice,
                            webUrlString: product.urlString,
                            imageUrlString: product.imageUrlString)
        // 1. 먼저 전체 장바구니에 담겨있는 상태인지?
        if isBasket, let oldFolder {
            let basketList = realmRepository.fetchItem(of: Basket.self)
            for basket in basketList {
                if basket.id == product.productID {
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
