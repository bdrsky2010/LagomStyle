//
//  UILabel+.swift
//  LagomStyle
//
//  Created by Minjae Kim on 6/19/24.
//

import UIKit

extension UILabel {
    static func blackRegular13(text: String? = nil) -> UILabel {
        let label = UILabel()
        label.text = text
        label.textColor = LagomStyle.AssetColor.lagomBlack
        label.font = LagomStyle.SystemFont.regular13
        return label
    }
    
    static func blackRegular14(text: String? = nil) -> UILabel {
        let label = UILabel()
        label.text = text
        label.textColor = LagomStyle.AssetColor.lagomBlack
        label.font = LagomStyle.SystemFont.regular14
        return label
    }
    
    static func blackRegular15(text: String? = nil) -> UILabel {
        let label = UILabel()
        label.text = text
        label.textColor = LagomStyle.AssetColor.lagomBlack
        label.font = LagomStyle.SystemFont.regular15
        return label
    }
    
    static func blackBold16(text: String? = nil) -> UILabel {
        let label = UILabel()
        label.text = text
        label.textColor = LagomStyle.AssetColor.lagomBlack
        label.font = LagomStyle.SystemFont.bold16
        return label
    }
    
    static func blackBlack14(text: String? = nil) -> UILabel {
        let label = UILabel()
        label.text = text
        label.textColor = LagomStyle.AssetColor.lagomBlack
        label.font = LagomStyle.SystemFont.black14
        return label
    }
    
    static func blackBlack16(text: String? = nil) -> UILabel {
        let label = UILabel()
        label.text = text
        label.textColor = LagomStyle.AssetColor.lagomBlack
        label.font = LagomStyle.SystemFont.black16
        return label
    }
    
    static func primaryRegular13(text: String? = nil) -> UILabel {
        let label = UILabel()
        label.text = text
        label.textColor = LagomStyle.AssetColor.lagomPrimaryColor
        label.font = LagomStyle.SystemFont.regular13
        return label
    }
    
    static func primaryBold13(text: String? = nil) -> UILabel {
        let label = UILabel()
        label.text = text
        label.textColor = LagomStyle.AssetColor.lagomPrimaryColor
        label.font = LagomStyle.SystemFont.bold13
        return label
    }
    
    static func grayRegular13(text: String? = nil) -> UILabel {
        let label = UILabel()
        label.text = text
        label.textColor = LagomStyle.AssetColor.lagomGray
        label.font = LagomStyle.SystemFont.regular13
        return label
    }
    
    static func lightGrayRegular13(text: String? = nil) -> UILabel {
        let label = UILabel()
        label.text = text
        label.textColor = LagomStyle.AssetColor.lagomLightGray
        label.font = LagomStyle.SystemFont.regular13
        return label
    }
}
