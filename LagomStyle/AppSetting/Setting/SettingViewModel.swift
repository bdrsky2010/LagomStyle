//
//  SettingViewModel.swift
//  LagomStyle
//
//  Created by Minjae Kim on 7/14/24.
//

import Foundation

import RealmSwift

enum SettingRouter {
    case profileEdit
    case basketFolder
}

final class SettingViewModel {
    private let realmRepository: RealmRepository
    
    var inputViewDidLoad: Observable<Void?> = Observable(nil)
    var inputDataFetch: Observable<Void?> = Observable(nil)
    var inputTableViewReloadData: Observable<Void?> = Observable(nil)
    var inputTableViewReloadRows: Observable<[IndexPath]> = Observable([])
    var inputPushNavigation: Observable<SettingRouter?> = Observable(nil)
    var inputDidWithdrawal: Observable<Void?> = Observable(nil)
    var inputDeleteDatabase: Observable<Void?> = Observable(nil)
    var inputChangeRootView: Observable<Void?> = Observable(nil)
    
    private(set) var outputDidConfigureView: Observable<Void?> = Observable(nil)
    private(set) var outputDidConfigureNavigationBarTitle: Observable<String> = Observable("")
    private(set) var outputDidTableViewReloadData: Observable<Void?> = Observable(nil)
    private(set) var outputDidTableViewReloadRows: Observable<[IndexPath]> = Observable([])
    private(set) var outputDidPushNavigation: Observable<SettingRouter?> = Observable(nil)
    private(set) var outputDidPresentWithdrawalAlert: Observable<(title: String, message: String)?> = Observable(nil)
    private(set) var outputDidChangeRootView: Observable<Void?> = Observable(nil)
    private(set) var outputDidUserDataFetch: Observable<UserTable?> = Observable(nil)
    private(set) var outputDidBasketDataFetch: Observable<Int> = Observable(0)
    
    init() {
        self.realmRepository = RealmRepository()
        bindData()
    }
    
    private func bindData() {
        inputViewDidLoad.bind { [weak self] _ in
            guard let self else { return }
            outputDidConfigureView.value = ()
            outputDidConfigureNavigationBarTitle.value = LagomStyle.Phrase.settingViewNavigationTitle
        }
        
        inputTableViewReloadData.bind { [weak self] _ in
            guard let self else { return }
            outputDidUserDataFetch.value = realmRepository.fetchItem(of: UserTable.self).first
            outputDidBasketDataFetch.value = realmRepository.fetchItem(of: Basket.self).count
            outputDidTableViewReloadData.value = ()
        }
        
        inputTableViewReloadRows.bind { [weak self] indexPaths in
            guard let self else { return }
            outputDidTableViewReloadRows.value = indexPaths
        }
        
        inputPushNavigation.bind { [weak self] router in
            guard let self, let router else { return }
            outputDidPushNavigation.value = router
        }
        
        inputDidWithdrawal.bind { [weak self] _ in
            guard let self else { return }
            outputDidPresentWithdrawalAlert.value = (LagomStyle.Phrase.withdrawalAlertTitle, LagomStyle.Phrase.withdrawalAlertMessage)
        }
        
        inputDeleteDatabase.bind { [weak self] _ in
            guard let self else { return }
            realmRepository.deleteDatabase()
            UserDefaultsHelper.removeUserDefaults(forKey: LagomStyle.UserDefaultsKey.isOnboarding)
        }
        
        inputChangeRootView.bind { [weak self] _ in
            guard let self else { return }
            outputDidChangeRootView.value = ()
        }
    }
    
    func getOptionPhraseCount() -> Int {
        return LagomStyle.Phrase.settingOptions.count
    }
    
    func getTableViewRowHeight(row: Int) -> Double {
        return row == 0 ? 120 : 44
    }
    
    func getOptionPhrase(index: Int) -> String {
        return LagomStyle.Phrase.settingOptions[index]
    }
}
