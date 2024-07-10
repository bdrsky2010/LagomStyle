//
//  ProfileSetupViewModel.swift
//  LagomStyle
//
//  Created by Minjae Kim on 7/10/24.
//

import Foundation

enum ValidationError: Error {
    case numberOfCharacter
    case specialCharacter
    case includeNumbers
}

final class ProfileSetupViewModel {
    private let totalFolderName = "전체"
    private let totalFolderOption = "장바구니 전체 목록 (*삭제불가)"
    private let etcFolderName = "그 외"
    private let etcFolderOption = "나머지 (*삭제불가)"
    private let realmRepository = RealmRepository()
    
    private(set) var outputIsCompleteButtonHidden: Observable<Bool?> = Observable(nil)
    private(set) var outputSelectedImage = Observable("")
    private(set) var outputTrimmedText: Observable<String> = Observable("")
    private(set) var outputIsValidNickname = Observable(false)
    private(set) var outputValidError: Observable<ValidationError?> = Observable(nil)
    private(set) var outputPushNavigationTrigger: Observable<Int?> = Observable(nil)
    private(set) var outputChangeRootViewTrigger: Observable<Void?> = Observable(nil)
    private(set) var outputPopViewTrigger: Observable<Void?> = Observable(nil)
    
    var inputViewDidLoadTrigger: Observable<LagomStyle.PFSetupOption?> = Observable(nil)
    var inputSelectedImageIndex = Observable(0)
    var inputDidChangeText: Observable<String> = Observable("")
    var inputNickname: Observable<String> = Observable("")
    var inputImageTapTrigger: Observable<Void?> = Observable(nil)
    var inputSaveDatabaseTrigger: Observable<LagomStyle.PFSetupOption?> = Observable(nil)
    
    init() {
        inputViewDidLoadTrigger.bind { [weak self] pfSetupType in
            guard let self, let pfSetupType else { return }
            switch pfSetupType {
            case .setup:
                inputSelectedImageIndex.value = Int.random(in: 0...11)
            case .edit:
                if let user = realmRepository.fetchItem(of: UserTable.self).first {
                    inputSelectedImageIndex.value = user.proflieImageIndex
                    inputNickname.value = user.nickname
                }
                outputIsCompleteButtonHidden.value = true
            }
        }
        
        inputSelectedImageIndex.bind { [weak self] selectedIndex in
            guard let self else { return }
            outputSelectedImage.value = LagomStyle.AssetImage.profile(index: selectedIndex).imageName
        }
        
        inputDidChangeText.bind { [weak self] text in
            guard let self else { return }
            outputTrimmedText.value = text.filter { $0 != " " }
        }
        
        inputNickname.bind { [weak self] nickname in
            guard let self else { return }
            completeValidateNickname(nickname)
        }
        
        inputImageTapTrigger.bind { [weak self] _ in
            guard let self else { return }
            outputPushNavigationTrigger.value = inputSelectedImageIndex.value
        }
        
        inputSaveDatabaseTrigger.bind { [weak self] pfSetupType in
            guard let self else { return }
            switch pfSetupType {
            case .setup:
                createDatabase()
            case .edit:
                updateDatabase()
            case nil:
                return
            }
        }
    }
    
    private func completeValidateNickname(_ nickname: String) {
        validateNickname(nickname) { result in
            switch result {
            case .success(let isValid):
                outputIsValidNickname.value = isValid
            case .failure(let error):
                outputValidError.value = error
            }
        }
    }
    
    private func validateNickname(_ nickname: String, completionHandler: (Result<Bool, ValidationError>) -> Void) {
        guard nickname.count >= 2, nickname.count < 10 else {
            completionHandler(.failure(.numberOfCharacter))
            return
        }
        
        for char in nickname {
            let string = String(char)
            if let _ = string.range(of: "^[@#$%]*$", options: .regularExpression) {
                completionHandler(.failure(.specialCharacter))
                return
            }
            if let _ = string.range(of: "^[0-9]*$", options: .regularExpression) {
                completionHandler(.failure(.includeNumbers))
                return
            }
        }
        completionHandler(.success(true))
    }
    
    private func createDatabase() {
        UserDefaultsHelper.isOnboarding = true
        
        let user = UserTable(nickname: inputNickname.value,
                             proflieImageIndex: inputSelectedImageIndex.value,
                             signupDate: Date())
        realmRepository.createItem(user)
        
        let totalFolder = Folder()
        totalFolder.name = totalFolderName
        totalFolder.option = totalFolderOption
        realmRepository.createItem(totalFolder)
        
        let etcFolder = Folder()
        etcFolder.name = etcFolderName
        etcFolder.option = etcFolderOption
        realmRepository.createItem(etcFolder)
        
        realmRepository.printDatebaseURL()
        
        outputChangeRootViewTrigger.value = ()
    }
    
    private func updateDatabase() {
        if let user = realmRepository.fetchItem(of: UserTable.self).first {
            let value: [String: Any] = [
                "id": user.id,
                "nickname": inputNickname.value,
                "proflieImageIndex": inputSelectedImageIndex.value
            ]
            realmRepository.updateItem(of: UserTable.self, value: value)
        }
        outputPopViewTrigger.value = ()
    }
}
