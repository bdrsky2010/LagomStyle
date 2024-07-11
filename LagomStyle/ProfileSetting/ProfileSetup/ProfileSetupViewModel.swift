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
    
    var warningPhrase: String {
        switch self {
        case .numberOfCharacter:
            return "2글자 이상 10글자 미만으로 설정해주세요( ´༎ຶㅂ༎ຶ`)"
        case .specialCharacter:
            return "닉네임에 @, #, $, % 는 포함할 수 없어요 (༎ຶ⌑༎ຶ)"
        case .includeNumbers:
            return "닉네임에 숫자는 포함할 수 없어요 ༼;´༎ຶ ۝ ༎ຶ༽"
        }
    }
}

final class ProfileSetupViewModel {
    private let realmRepository: RealmRepository
    
    var inputViewDidLoadTrigger: Observable<LagomStyle.PFSetupOption?> = Observable(nil)
    var inputSelectedImageIndex = Observable(0)
    var inputChangeText: Observable<String> = Observable("")
    var inputNickname: Observable<String> = Observable("")
    var inputImageTapTrigger: Observable<Void?> = Observable(nil)
    var inputSaveDatabaseTrigger: Observable<LagomStyle.PFSetupOption?> = Observable(nil)
    
    private(set) var outputDidCheckIsEditOption: Observable<(isHidden: Bool, nickname: String)?> = Observable(nil)
    private(set) var outputDidSelectedImage = Observable("")
    private(set) var outputDidTrimmedText: Observable<String> = Observable("")
    private(set) var outputDidCheckIsValidNickname = Observable(false)
    private(set) var outputDidSendValidError: Observable<ValidationError?> = Observable(nil)
    private(set) var outputDidPushNavigationTrigger: Observable<Int?> = Observable(nil)
    private(set) var outputDidChangeRootViewTrigger: Observable<Void?> = Observable(nil)
    private(set) var outputDidPopViewTrigger: Observable<Void?> = Observable(nil)
    
    init() {
        self.realmRepository = RealmRepository()
        bindData()
    }
    
    private func bindData() {
        inputViewDidLoadTrigger.bind { [weak self] pfSetupType in
            guard let self, let pfSetupType else { return }
            switch pfSetupType {
            case .setup:
                inputSelectedImageIndex.value = Int.random(in: 0...11)
            case .edit:
                if let user = realmRepository.fetchItem(of: UserTable.self).first {
                    inputSelectedImageIndex.value = user.proflieImageIndex
                    inputNickname.value = user.nickname
                    outputDidCheckIsEditOption.value = (true, user.nickname)
                }
            }
        }
        
        inputSelectedImageIndex.bind { [weak self] selectedIndex in
            guard let self else { return }
            outputDidSelectedImage.value = LagomStyle.AssetImage.profile(index: selectedIndex).imageName
        }
        
        inputChangeText.bind { [weak self] text in
            guard let self else { return }
            outputDidTrimmedText.value = text.filter { $0 != " " }
        }
        
        inputNickname.bind { [weak self] nickname in
            guard let self else { return }
            completeValidateNickname(nickname)
        }
        
        inputImageTapTrigger.bind { [weak self] _ in
            guard let self else { return }
            outputDidPushNavigationTrigger.value = inputSelectedImageIndex.value
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
                outputDidCheckIsValidNickname.value = isValid
            case .failure(let error):
                outputDidSendValidError.value = error
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
        totalFolder.name = "전체"
        totalFolder.option = "장바구니 전체 목록 (*삭제불가)"
        realmRepository.createItem(totalFolder)
        
        let etcFolder = Folder()
        etcFolder.name = "그 외"
        etcFolder.option = "나머지 (*삭제불가)"
        realmRepository.createItem(etcFolder)
        
        realmRepository.printDatebaseURL()
        
        outputDidChangeRootViewTrigger.value = ()
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
        outputDidPopViewTrigger.value = ()
    }
}
