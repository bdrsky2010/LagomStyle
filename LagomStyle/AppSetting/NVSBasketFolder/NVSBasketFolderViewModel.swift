//
//  NVSBasketFolderViewModel.swift
//  LagomStyle
//
//  Created by Minjae Kim on 7/15/24.
//

import Foundation

import RealmSwift

final class NVSBasketFolderViewModel {
    private let realmRepository: RealmRepository
    
    private var folders: Results<Folder> {
        return realmRepository.fetchItem(of: Folder.self)
    }
    private var baskets: Results<Basket> {
        return realmRepository.fetchItem(of: Basket.self)
    }
    
    var inputViewDidLoad: Observable<Void?> = Observable(nil)
    var inputViewWillAppear: Observable<Void?> = Observable(nil)
    var inputTableViewReloadData: Observable<Void?> = Observable(nil)
    var inputFetchData: Observable<Void?> = Observable(nil)
    var inputTableViewReloadRows: Observable<[IndexPath]> = Observable([])
    var inputDeleteFolder: Observable<IndexPath?> = Observable(nil)
    var inputPlusButtonClicked: Observable<Void?> = Observable(nil)
    var inputDidSelectRowAt: Observable<IndexPath?> = Observable(nil)
    
    private(set) var outputDidConfigureView: Observable<Void?> = Observable(nil)
    private(set) var outputDidConfigureNavigation: Observable<(title: String, image: String)?> = Observable(nil)
    private(set) var outputDidFetchFolderData: Observable<[Folder]> = Observable([])
    private(set) var outputDidFetchBasketData: Observable<[Basket]> = Observable([])
    private(set) var outputDidTableViewReloadData: Observable<Void?> = Observable(nil)
    private(set) var outputDidTableViewReloadRows: Observable<[IndexPath]> = Observable([])
    private(set) var outputDidTableViewDeleteRows: Observable<[IndexPath]> = Observable([])
    private(set) var outputDidPresentAddFolderView: Observable<Void?> = Observable(nil)
    private(set) var outputDidPushNavigation: Observable<(indexPath: IndexPath, folder: Folder)?> = Observable(nil)
    
    init() {
        self.realmRepository = RealmRepository()
        bindData()
    }
    
    private func bindData() {
        inputViewDidLoad.bind { [weak self] _ in
            guard let self else { return }
            outputDidConfigureView.value = ()
            outputDidConfigureNavigation.value = ("장바구니 폴더 목록", LagomStyle.SystemImage.plus)
            inputTableViewReloadData.value = ()
        }
        
        inputViewWillAppear.bind { [weak self] _ in
            guard let self else { return }
            inputTableViewReloadData.value = ()
        }
        
        inputTableViewReloadData.bind { [weak self] _ in
            guard let self else { return }
            inputFetchData.value = ()
            outputDidTableViewReloadData.value = ()
        }
        
        inputFetchData.bind { [weak self] _ in
            guard let self else { return }
            outputDidFetchFolderData.value = Array(folders)
            outputDidFetchBasketData.value = Array(baskets)
        }
        
        inputTableViewReloadRows.bind { [weak self] indexPaths in
            guard let self else { return }
            outputDidTableViewReloadRows.value = indexPaths
        }
        
        inputDeleteFolder.bind { [weak self] indexPath in
            guard let self, let indexPath else { return }
            let folder = folders[indexPath.row]
            realmRepository.deleteItem(folder)
            inputFetchData.value = ()
            outputDidTableViewDeleteRows.value = [indexPath]
        }
        
        inputPlusButtonClicked.bind { [weak self] _ in
            guard let self else { return }
            outputDidPresentAddFolderView.value = ()
        }
        
        inputDidSelectRowAt.bind { [weak self] indexPath in
            guard let self, let indexPath else { return }
            let folder = folders[indexPath.row]
            outputDidPushNavigation.value = (indexPath, folder)
        }
    }
}
