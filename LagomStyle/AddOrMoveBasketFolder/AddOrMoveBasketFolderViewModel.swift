//
//  AddOrMoveBasketFolderViewModel.swift
//  LagomStyle
//
//  Created by Minjae Kim on 7/15/24.
//

import Foundation

import RealmSwift

final class AddOrMoveBasketFolderViewModel {
    private let realmRepository: RealmRepository
    
    var inputInitProductID: Observable<String> = Observable("")
    var inputViewDidLoad: Observable<Void?> = Observable(nil)
    var inputDismissButtonClicked: Observable<Void?> = Observable(nil)
    
    private(set) var outputDidFetchFolderData: Observable<[Folder]> = Observable([])
    private(set) var outputDidConfigureNavigation: Observable<(title: String, image: String)?> = Observable(nil)
    private(set) var outputDidConfigureView: Observable<Void?> = Observable(nil)
    private(set) var outputDidDismiss: Observable<Void?> = Observable(nil)
    
    init() {
        self.realmRepository = RealmRepository()
        bindData()
    }
    
    private func bindData() {
        inputViewDidLoad.bind { [weak self] _ in
            guard let self else { return }
            outputDidFetchFolderData.value = Array(realmRepository.fetchItem(of: Folder.self))
            outputDidConfigureNavigation.value = ("폴더 선택", LagomStyle.SystemImage.xmark)
            outputDidConfigureView.value = ()
        }
        
        inputDismissButtonClicked.bind { [weak self] _ in
            guard let self else { return }
            outputDidDismiss.value = ()
        }
    }
    
    func isProductExistFolder(_ folder: Folder) -> Bool {
        return folder.detail.contains(where: { $0.id == inputInitProductID.value })
    }
}
