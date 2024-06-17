//
//  Resource.swift
//  LagomStyle
//
//  Created by Minjae Kim on 6/13/24.
//

import UIKit

// MARK: LagomStyle App에서 사용되는 Resource 정의
enum LagomStyle {
    
    // MARK: App에서 사용되는 문구들
    enum phrase {
        static let onBoardingAppTitle = "Lagom\nStyle"
        static let onBoardingStart = "시작하기"
        
        static let searchTabBarTitle = "검색"
        static let settingTabBarTitle = "설정"
        
        static let profileSettingPlaceholder = "닉네임을 입력해주세요 :)"
        static let profileSettingComplete = "완료"
        
        static let searchViewNavigationTitle = "'s LagomStyle"
        static let searchViewPlaceholder = "브랜드, 상품 등을 입력하세요."
        static let searchViewRecentSearch = "최근 검색"
        static let searchViewNoRecentSearch = "최근 검색어가 없어요"
        static let searchViewRemoveAll = "전체 삭제"
        
        static let searchResultCount = "개의 검색 결과"
        
        static let settingViewNavigationTitle = "SETTING"
        static let settingOptions = ["", "나의 장바구니 목록", "자주 묻는 질문", "1:1 문의", "알림 설정", "탈퇴하기"]
        
        static let availableNickname = "사용 가능한 닉네임입니다 ୧༼ ヘ ᗜ ヘ ༽୨"
        static let numberOfCharacterX = "2글자 이상 10글자 미만으로 설정해주세요( ´༎ຶㅂ༎ຶ`)"
        static let specialCharacterX = "닉네임에 @, #, $, % 는 포함할 수 없어요 (༎ຶ⌑༎ຶ)"
        static let includeNumbers = "닉네임에 숫자는 포함할 수 없어요 ༼;´༎ຶ ۝ ༎ຶ༽"
        
        static let withDrawAlertTitle = "탈퇴하기"
        static let withDrawAlertMessage = "탈퇴하면 모든 데이터가 초기화됩니다. 탈퇴 하시겠습니까?"
    }
    
    // MARK: App에서 사용되는 UIColor Data
    enum Color {
        static let lagomPrimaryColor = UIColor.lagomOrange
        static let lagomBlack = UIColor.lagomBlack
        static let lagomGray = UIColor.lagomGray
        static let lagomDarkGray = UIColor.lagomDarkGray
        static let lagomLightGray = UIColor.lagomLightGray
        static let lagomWhite = UIColor.lagomWhite
    }
    
    // MARK: App에서 사용되는 Image Set 이름
    enum Image {
        case empty
        case launch
        case like(selected: Bool)
        case profile(index: Int)
        
        var imageName: String {
            switch self {
            case .empty:
                return String(describing: self)
            case .launch:
                return String(describing: self)
            case .like(let selected):
                return "like_\(selected ? "selected" : "unselected")"
            case .profile(let index):
                return "profile_\(index)"
            }
        }
    }
    
    // MARK: App에서 사용되는 System Image 이름
    enum SystemImage {
        static let magnifyingglass = "magnifyingglass"
        static let person = "person"
        static let chevronRight = "chevron.right"
        static let chevronLeft = "chevron.left"
        static let clock = "clock"
        static let xmark = "xmark"
        static let cameraFill = "camera.fill"
    }
    
    // MARK: App에서 사용되는 선택O / 선택X 에 따른 프로필 이미지 border 및 camera image(isHidden) 설정 값
    struct SetProfileImageConfigure {
        let borderColor: CGColor
        let borderWidth: CGFloat
        let opacity: Float
        let isCameraHidden: Bool
        
        static let select = SetProfileImageConfigure(
            borderColor: LagomStyle.Color.lagomPrimaryColor.cgColor, borderWidth: 3, opacity: 1, isCameraHidden: true)
        static let selected = SetProfileImageConfigure(
            borderColor: LagomStyle.Color.lagomPrimaryColor.cgColor, borderWidth: 5, opacity: 1, isCameraHidden: false)
        static let unselect = SetProfileImageConfigure(
            borderColor: LagomStyle.Color.lagomLightGray.cgColor, borderWidth: 1, opacity: 0.5, isCameraHidden: true)
    }
    
    // MARK: App에서 사용되는 Text들의 Font
    enum Font {
        static let regular13 = UIFont.systemFont(ofSize: 13)
        static let regular14 = UIFont.systemFont(ofSize: 14)
        static let regular15 = UIFont.systemFont(ofSize: 15)
        static let regular16 = UIFont.systemFont(ofSize: 16)
        
        static let bold13 = UIFont.boldSystemFont(ofSize: 13)
        static let bold14 = UIFont.boldSystemFont(ofSize: 14)
        static let bold15 = UIFont.boldSystemFont(ofSize: 15)
        static let bold16 = UIFont.boldSystemFont(ofSize: 16)
        
        static let black13 = UIFont.systemFont(ofSize: 13, weight: .black)
        static let black14 = UIFont.systemFont(ofSize: 14, weight: .black)
        static let black15 = UIFont.systemFont(ofSize: 15, weight: .black)
        static let black16 = UIFont.systemFont(ofSize: 16, weight: .black)
        static let black50 = UIFont.systemFont(ofSize: 50, weight: .black)
    }
    
    // MARK: App에서 사용되는 UserDefaults Key
    enum UserDefaultsKey {
        static let isOnboarding = "isOnboarding"
        static let nickname = "nickname"
        static let signUpDate = "signUpDate"
        static let profileImageIndex = "profileImageIndex"
        static let recentSearchQueries = "recentSearchQueries"
        static let likeProducts = "likeProducts"
    }
    
    // MARK: Profile Setup Option: setup OR edit
    enum PFSetupOption {
        case setup
        case edit
        
        var title: String {
            switch self {
            case .setup:
                return "PROFILE SETTING"
            case .edit:
                return "EDIT PROFILE"
            }
        }
    }
    
    // MARK: Profile Image Type: select OR unselect
    enum PFImageSelectType {
        case select
        case selected
        case unselect
        
        var imageConfigure: LagomStyle.SetProfileImageConfigure {
            switch self {
            case .select:
                return LagomStyle.SetProfileImageConfigure.select
            case .selected:
                return LagomStyle.SetProfileImageConfigure.selected
            case .unselect:
                return LagomStyle.SetProfileImageConfigure.unselect
            }
        }
    }
}
