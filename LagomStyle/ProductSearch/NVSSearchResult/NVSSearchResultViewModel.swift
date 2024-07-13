//
//  NVSSearchResultViewModel.swift
//  LagomStyle
//
//  Created by Minjae Kim on 7/13/24.
//

import Foundation

final class NVSSearchResultViewModel {
    private let realmRepository: RealmRepository
    private let searchDisplayCount = 30
    
    var inputReceiveQueryString: Observable<String> = Observable("")
    var inputViewDidLoadTrigger: Observable<Void?> = Observable(nil)
    
    var inputNVSSSortType: Observable<NVSSSort> = Observable(.sim)
    var inputNVSSStartNumber: Observable<Int> = Observable(1)
    
    private(set) var outputDidSetNavigationTitle: Observable<String> = Observable("")
    private(set) var outputDidConfigureView: Observable<Void?> = Observable(nil)
    
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
    }
}
