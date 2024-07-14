//
//  AddBasketFolderViewModel.swift
//  LagomStyle
//
//  Created by Minjae Kim on 7/15/24.
//

import Foundation

import RealmSwift

final class AddBasketFolderViewModel {
    private let realmRepository: RealmRepository
    
    var inputViewDidLoad: Observable<Void?> = Observable(nil)
    var inputDismissButtonClicked: Observable<Void?> = Observable(nil)
    var inputAddButtonClicked: Observable<(title: String, option: String)?> = Observable(nil)
    var inputIsEmptyTitleText: Observable<Bool> = Observable(true)
    var inputIsEmptyOptionText: Observable<Bool> = Observable(true)
    var inputCheckTextFields: Observable<Void?> = Observable(nil)
    
    private(set) var outputDidConfigureView: Observable<Void?> = Observable(nil)
    private(set) var outputDidConfigureNavigation: Observable<String> = Observable("")
    private(set) var outputDidDismiss: Observable<Void?> = Observable(nil)
    private(set) var outputDidDismissWithAddFolder: Observable<Void?> = Observable(nil)
    private(set) var outputDidCheckIsEnabledAddButton: Observable<Bool> = Observable(false)
    
    init() {
        self.realmRepository = RealmRepository()
        bindData()
    }
    
    private func bindData() {
        inputViewDidLoad.bind { [weak self] _ in
            guard let self else { return }
            outputDidConfigureView.value = ()
            outputDidConfigureNavigation.value = LagomStyle.SystemImage.xmark
        }
        
        inputDismissButtonClicked.bind { [weak self] _ in
            guard let self else { return }
            outputDidDismiss.value = ()
        }
        
        inputAddButtonClicked.bind { [weak self] tuple in
            guard let self, let tuple else { return }
            let folder = Folder()
            folder.name = tuple.title
            folder.option = tuple.option
            folder.regDate = Date()
            realmRepository.createItem(folder)
            outputDidDismissWithAddFolder.value = ()
        }
        
        inputCheckTextFields.bind { [weak self] _ in
            guard let self else { return }
            outputDidCheckIsEnabledAddButton.value = !inputIsEmptyTitleText.value && !inputIsEmptyOptionText.value
        }
    }
}
