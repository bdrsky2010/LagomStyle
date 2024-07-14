//
//  NVSBasketViewModel.swift
//  LagomStyle
//
//  Created by Minjae Kim on 7/15/24.
//

import Foundation

import RealmSwift

final class NVSBasketViewModel {
    private let realmRepository: RealmRepository
    
    var inputInitViewController: Observable<Folder?> = Observable(nil)
    var inputViewDidLoad: Observable<Void?> = Observable(nil)
    var inputCollectionViewReloadData: Observable<Void?> = Observable(nil)
    var inputFetchBasketData: Observable<Void?> = Observable(nil)
    var inputDidSelectItemAt: Observable<Int> = Observable(0)
    var inputSaveBasketData: Observable<(row: Int, isBasket: Bool, oldFolder: Folder, newFolder: Folder)?> = Observable(nil)
    var inputBasketButtonTapped: Observable<Int> = Observable(0)
    var inputOnChangeBasket: Observable<(row: Int, isBasket: Bool, oldFolder: Folder, newFolder: Folder)?> = Observable(nil)
    var inputOnChangeFolder: Observable<(row: Int, newFolder: Folder)?> = Observable(nil)
    
    private(set) var outputDidCheckIsTotalFolder: Observable<Bool> = Observable(false)
    private(set) var outputDidGetFolder: Observable<Folder?> = Observable(nil)
    private(set) var outputDidSetTotalBasketList: Observable<[Basket]> = Observable([])
    private(set) var outputDidSetFolderBasketList: Observable<[Basket]> = Observable([])
    private(set) var outputDidConfigureNavigation: Observable<String> = Observable("")
    private(set) var outputDidConfigureView: Observable<Void?> = Observable(nil)
    private(set) var outputDidCollectionViewReloadData: Observable<Void?> = Observable(nil)
    private(set) var outputDidPushNavigation: Observable<Int> = Observable(0)
    private(set) var outputDidPresentFolderModal: Observable<(selectedBasket: Basket, index: Int)?> = Observable(nil)
    
    init() {
        self.realmRepository = RealmRepository()
        bindData()
    }
    
    private func bindData() {
        inputInitViewController.bind { [weak self] folder in
            guard let self, let folder else { return }
            outputDidCheckIsTotalFolder.value = isTotalFolder(folder)
            outputDidGetFolder.value = folder
            outputDidConfigureNavigation.value = folder.name
            inputFetchBasketData.value = ()
        }
        
        inputViewDidLoad.bind { [weak self] _ in
            guard let self else { return }
            outputDidConfigureView.value = ()
        }
        
        inputCollectionViewReloadData.bind { [weak self] _ in
            guard let self else { return }
            inputFetchBasketData.value = ()
            outputDidCollectionViewReloadData.value = ()
        }
        
        inputFetchBasketData.bind { [weak self] _ in
            guard let self else { return }
            outputDidSetFolderBasketList.value = fetchFolderBasketData()
            outputDidSetTotalBasketList.value = fetchTotalBasketData()
        }
        
        inputDidSelectItemAt.bind { [weak self] row in
            guard let self else { return }
            outputDidPushNavigation.value = row
        }
        
        inputSaveBasketData.bind { [weak self] tuple in
            guard let self, let tuple else { return }
            saveBasketData(row: tuple.row, isBasket: tuple.isBasket, oldFolder: tuple.oldFolder, newFolder: tuple.oldFolder)
        }
        
        inputBasketButtonTapped.bind { [weak self] tag in
            guard let self, let folder = outputDidGetFolder.value else { return }
            let selectedBasket = isTotalFolder(folder) ? outputDidSetTotalBasketList.value[tag] : outputDidSetFolderBasketList.value[tag]
            outputDidPresentFolderModal.value = (selectedBasket, tag)
        }
        
        inputOnChangeBasket.bind { [weak self] tuple in
            guard let self, let tuple else { return }
            saveBasketData(row: tuple.row, isBasket: tuple.isBasket, oldFolder: tuple.oldFolder, newFolder: tuple.newFolder)
        }
        
        inputOnChangeFolder.bind { [weak self] tuple in
            guard let self, let tuple, let folder = outputDidGetFolder.value else { return }
            var oldFolder: Folder?
            let selectedBasket = isTotalFolder(folder) ? outputDidSetTotalBasketList.value[tuple.row] : outputDidSetFolderBasketList.value[tuple.row]
            let isBasket = isBasketExistOnBasket(basket: selectedBasket) { folder in
                oldFolder = folder
            }
            if let oldFolder {
                saveBasketData(row: tuple.row, isBasket: isBasket, oldFolder: oldFolder, newFolder: tuple.newFolder)
            }
        }
    }
    
    private func isTotalFolder(_ folder: Folder) -> Bool {
        if let totalFolder = realmRepository.fetchItem(of: Folder.self).first {
            return totalFolder.id == folder.id
        } else {
            return false
        }
    }
    
    private func fetchFolderBasketData() -> [Basket] {
        if let folder = outputDidGetFolder.value {
            return Array(folder.detail)
        }
        return []
    }
    
    private func fetchTotalBasketData() -> [Basket] {
        return Array(realmRepository.fetchItem(of: Basket.self))
    }
    
    func isBasketExistOnBasket(basket selectedBasket: Basket, completionHandler: ((Folder?) -> Void)? = nil) -> Bool {
        let basketList = realmRepository.fetchItem(of: Basket.self)
        var isBasket = false
        for basket in basketList {
            if basket.id == selectedBasket.id {
                isBasket = true
                completionHandler?(basket.folder.first)
                break
            }
        }
        return isBasket
    }
    
    private func saveBasketData(row: Int, isBasket: Bool, oldFolder: Folder, newFolder: Folder) {
        defer {
            inputCollectionViewReloadData.value = ()
        }
        // 장바구니 데이터에 대한 object에 대해 삭제가 일어나면 해당 객체에 대한 접근이 안되기 때문에
        let oldBasket = outputDidCheckIsTotalFolder.value ? outputDidSetTotalBasketList.value[row] : outputDidSetFolderBasketList.value[row]
        // 새로 Basket 인스턴스 생성
        let newBasket = Basket(id: oldBasket.id,
                               name: oldBasket.name,
                               mallName: oldBasket.mallName,
                               lowPrice: oldBasket.lowPrice,
                               webUrlString: oldBasket.webUrlString,
                               imageUrlString: oldBasket.imageUrlString)
        // 1. 담겨있는 폴더와 같은 폴더를 받아왔는지?
        realmRepository.deleteItem(oldBasket)
        if oldFolder.id == newFolder.id {
            // 2. 같은 폴더를 받아왔다면 '전체 장바구니에서 해당 상품 삭제'
            return
        } else {
            // 3. 다른 폴더를 받아왔다면 '전체 장바구니에서 해당 상품 삭제' 후 받아온 폴더에 추가
            realmRepository.createItem(newBasket, folder: newFolder)
        }
    }
}
