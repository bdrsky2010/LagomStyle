//
//  NVSProductDetailViewModel.swift
//  LagomStyle
//
//  Created by Minjae Kim on 7/15/24.
//

import Foundation

import RealmSwift

final class NVSProductDetailViewModel {
    private let realmRepository: RealmRepository
    
    private var isBasket: Bool {
        guard let product = inputInitProduct.value else { return false }
        return realmRepository.fetchItem(of: Basket.self).contains(where: { $0.id == product.id })
    }
    
    var inputInitRow: Observable<Int> = Observable(0)
    var inputInitProduct: Observable<CommonProduct?> = Observable(nil)
    var inputViewDidLoad: Observable<Void?> = Observable(nil)
    var inputBasketButtonClicked: Observable<Void?> = Observable(nil)
    var inputOnChangeFolder: Observable<(oldFolder: Folder?, newFolder: Folder)?> = Observable(nil)
    
    private(set) var outputDidConfigureNavigation: Observable<(title: String, image: String)?> = Observable(nil)
    private(set) var outputDidRequestWebView: Observable<URLRequest?> = Observable(nil)
    private(set) var outputDidPresentAddOrMoveBasketFolderView: Observable<(id: String, row: Int)?> = Observable(nil)
    private(set) var outputDidReconfigureNavigation: Observable<String> = Observable("")
    
    init() {
        self.realmRepository = RealmRepository()
        bindData()
    }
    
    private func bindData() {
        inputInitProduct.bind { [weak self] product in
            guard let self, let product else { return }
            let image = LagomStyle.AssetImage.like(selected: isBasket).imageName
            outputDidConfigureNavigation.value = (product.title, image)
        }
        
        inputViewDidLoad.bind { [weak self] _ in
            guard let self, let product = inputInitProduct.value else { return }
            
            if let url = URL(string: product.webUrlString) {
                let request = URLRequest(url: url)
                outputDidRequestWebView.value = request
            }
        }
        
        inputBasketButtonClicked.bind { [weak self] _ in
            guard let self, let product = inputInitProduct.value else { return }
            outputDidPresentAddOrMoveBasketFolderView.value = (product.id, inputInitRow.value)
        }
        
        inputOnChangeFolder.bind { [weak self] tuple in
            guard let self, let tuple else { return }
            if let oldFolder = tuple.oldFolder {
                outputDidReconfigureNavigation.value = LagomStyle.AssetImage.like(selected: oldFolder.id != tuple.newFolder.id).imageName
            } else {
                outputDidReconfigureNavigation.value = LagomStyle.AssetImage.like(selected: true).imageName
            }
        }
    }
    
    func isProductExistBasket(_ productID: String, completionHandler: (Folder?) -> Void) -> Bool {
        var isBasket = false
        let basketList = realmRepository.fetchItem(of: Basket.self)
        for basket in basketList {
            if basket.id == productID {
                isBasket = true
                completionHandler(basket.folder.first)
                break
            }
        }
        return isBasket
    }
}
