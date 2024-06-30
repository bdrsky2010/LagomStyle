//
//  Resource + PFSetup.swift
//  LagomStyle
//
//  Created by Minjae Kim on 6/30/24.
//

import UIKit

extension LagomStyle {
    // MARK: App에서 사용되는 선택O / 선택X 에 따른 프로필 이미지 border 및 camera image(isHidden) 설정 값
    struct SetProfileImageConfigure {
        let borderColor: CGColor
        let borderWidth: CGFloat
        let opacity: Float
        let isCameraHidden: Bool
        
        static let select = SetProfileImageConfigure(
            borderColor: LagomStyle.AssetColor.lagomPrimaryColor.cgColor, borderWidth: 3, opacity: 1, isCameraHidden: true)
        static let selected = SetProfileImageConfigure(
            borderColor: LagomStyle.AssetColor.lagomPrimaryColor.cgColor, borderWidth: 5, opacity: 1, isCameraHidden: false)
        static let unselect = SetProfileImageConfigure(
            borderColor: LagomStyle.AssetColor.lagomLightGray.cgColor, borderWidth: 1, opacity: 0.5, isCameraHidden: true)
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
