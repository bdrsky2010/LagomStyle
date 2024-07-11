//
//  ProfileImageSetupViewModel.swift
//  LagomStyle
//
//  Created by Minjae Kim on 7/11/24.
//

import Foundation

final class ProfileImageSetupViewModel {
    
    var inputViewDidLoadTrigger: Observable<Void?> = Observable(nil)
    var inputSelectedImageIndex: Observable<Int?> = Observable(nil)
    
    private(set) var outputDidConfigureProfileImage: Observable<Int?> = Observable(nil)
    private(set) var outputDidSelectedImageIndex: Observable<Int?> = Observable(nil)
    
    init(selectedImageIndex: Int) {
        self.inputSelectedImageIndex.value = selectedImageIndex
        bindData()
    }
    
    private func bindData() {
        inputViewDidLoadTrigger.bind { [weak self] _ in
            guard let self else { return }
            outputDidConfigureProfileImage.value = inputSelectedImageIndex.value
        }
        
        inputSelectedImageIndex.bind { [weak self] index in
            guard let self else { return }
            outputDidSelectedImageIndex.value = inputSelectedImageIndex.value
        }
    }
}
