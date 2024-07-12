//
//  NVSSearchViewModel.swift
//  LagomStyle
//
//  Created by Minjae Kim on 7/12/24.
//

import Foundation

import RealmSwift

final class NVSSearchViewModel {
    private let realmRepository: RealmRepository
    
    var inputViewDidLoadTrigger: Observable<Void?> = Observable(nil)
    var inputTableViewReloadTrigger: Observable<Void?> = Observable(nil)
    var inputViewWillAppearTrigger: Observable<Void?> = Observable(nil)
    var inputClickedRemoveAllButton: Observable<Void?> = Observable(nil)
    var inputTextFieldShouldReturn: Observable<String> = Observable("")
    var inputPushSearchResultViewTrigger: Observable<String> = Observable("")
    var inputClickedRemoveButton: Observable<Int> = Observable(0)
    
    private(set) var outputDidConfigureViewTrigger: Observable<Void?> = Observable(nil)
    private(set) var outputDidChangeNavigationTitle: Observable<String> = Observable("")
    private(set) var outputDidChangeRecentSearchList: Observable<[String]> = Observable([])
    private(set) var outputDidPushSearchResultViewTrigger: Observable<String> = Observable("")
    
    init() {
        self.realmRepository = RealmRepository()
        bindData()
    }
    
    private func bindData() {
        inputViewDidLoadTrigger.bind { [weak self] _ in
            guard let self, let user = fetchUserData() else { return }
            outputDidConfigureViewTrigger.value = ()
            fetchUserNickname(user.nickname)
        }
        
        inputViewWillAppearTrigger.bind { [weak self] _ in
            guard let self, let user = fetchUserData() else { return }
            fetchUserNickname(user.nickname)
        }
        
        inputTableViewReloadTrigger.bind { [weak self] _ in
            guard let self, let user = fetchUserData() else { return }
            fetchRecentSearchList(user.recentSearchKeyword)
        }
        
        inputClickedRemoveAllButton.bind { [weak self] _ in
            guard let self else { return }
            deleteRecentSearchList()
        }
        
        inputTextFieldShouldReturn.bind { [weak self] query in
            guard let self else { return }
            updateRecentSearchKeyword(query)
        }
        
        inputPushSearchResultViewTrigger.bind { [weak self] query in
            guard let self else { return }
            outputDidPushSearchResultViewTrigger.value = query
        }
        
        inputClickedRemoveButton.bind { [weak self] index in
            guard let self else { return }
            let query = outputDidChangeRecentSearchList.value[index]
            deleteRecentSearchKeyword(query)
        }
    }
    
    private func fetchUserData() -> UserTable? {
        return realmRepository.fetchItem(of: UserTable.self).first
    }
    
    private func fetchUserNickname(_ nickname: String) {
        outputDidChangeNavigationTitle.value = nickname + LagomStyle.Phrase.searchViewNavigationTitle
    }
    
    private func fetchRecentSearchList(_ recentSearchKeyword: Map<String, Date>) {
        outputDidChangeRecentSearchList.value = recentSearchKeyword.sorted(by: { $0.value > $1.value }).map { $0.key }
    }
    
    private func deleteRecentSearchList() {
        guard let user = fetchUserData() else { return }
        realmRepository.updateItem {
            user.recentSearchKeyword.removeAll()
        }
    }
    
    private func updateRecentSearchKeyword(_ query: String) {
        guard let user = fetchUserData() else { return }
        realmRepository.updateItem {
            user.recentSearchKeyword.setValue(Date(), forKey: query)
        }
    }
    
    private func deleteRecentSearchKeyword(_ query: String) {
        guard let user = fetchUserData() else { return }
        realmRepository.updateItem {
            user.recentSearchKeyword.removeObject(for: query)
        }
    }
}
