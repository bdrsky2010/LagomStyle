//
//  Resource + Phrase.swift
//  LagomStyle
//
//  Created by Minjae Kim on 6/30/24.
//

import Foundation

// MARK: LagomStyle App에서 사용되는 Resource 정의
enum LagomStyle { }

// MARK: App에서 사용되는 문구들
extension LagomStyle {
    enum Phrase {
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
        static let searchEmptyResult = "검색 결과가 없어요"
        
        static let settingViewNavigationTitle = "SETTING"
        static let settingOptions = ["", "나의 장바구니 목록", "자주 묻는 질문", "1:1 문의", "알림 설정", "탈퇴하기"]
        
        static let availableNickname = "사용 가능한 닉네임입니다 ୧༼ ヘ ᗜ ヘ ༽୨"
        static let numberOfCharacterX = "2글자 이상 10글자 미만으로 설정해주세요( ´༎ຶㅂ༎ຶ`)"
        static let specialCharacterX = "닉네임에 @, #, $, % 는 포함할 수 없어요 (༎ຶ⌑༎ຶ)"
        static let includeNumbers = "닉네임에 숫자는 포함할 수 없어요 ༼;´༎ຶ ۝ ༎ຶ༽"
        static let unknownError = "알 수 없는 에러가 발생했어요 ༼;´༎ຶ ۝ ༎ຶ༽"
        
        static let basketViewNavigationTitle = "살까 말까 고민하지 마."
        
        static let withDrawAlertTitle = "탈퇴하기"
        static let withDrawAlertMessage = "탈퇴하면 모든 데이터가 초기화됩니다. 탈퇴 하시겠습니까?"
    }
}
