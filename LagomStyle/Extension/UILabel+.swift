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
        label.textColor = LagomStyle.Color.lagomBlack
        label.font = LagomStyle.Font.regular13
        return label
    }
    
    static func blackRegular14(text: String? = nil) -> UILabel {
        let label = UILabel()
        label.text = text
        label.textColor = LagomStyle.Color.lagomBlack
        label.font = LagomStyle.Font.regular14
        return label
    }
    
    static func blackRegular15(text: String? = nil) -> UILabel {
        let label = UILabel()
        label.text = text
        label.textColor = LagomStyle.Color.lagomBlack
        label.font = LagomStyle.Font.regular15
        return label
    }
    
    static func blackBold16(text: String? = nil) -> UILabel {
        let label = UILabel()
        label.text = text
        label.textColor = LagomStyle.Color.lagomBlack
        label.font = LagomStyle.Font.bold16
        return label
    }
    
    static func blackBlack14(text: String? = nil) -> UILabel {
        let label = UILabel()
        label.text = text
        label.textColor = LagomStyle.Color.lagomBlack
        label.font = LagomStyle.Font.black14
        return label
    }
    
    static func blackBlack16(text: String? = nil) -> UILabel {
        let label = UILabel()
        label.text = text
        label.textColor = LagomStyle.Color.lagomBlack
        label.font = LagomStyle.Font.black16
        return label
    }
    
    static func primaryRegular13(text: String? = nil) -> UILabel {
        let label = UILabel()
        label.text = text
        label.textColor = LagomStyle.Color.lagomPrimaryColor
        label.font = LagomStyle.Font.regular13
        return label
    }
    
    static func primaryBold13(text: String? = nil) -> UILabel {
        let label = UILabel()
        label.text = text
        label.textColor = LagomStyle.Color.lagomPrimaryColor
        label.font = LagomStyle.Font.bold13
        return label
    }
    
    static func grayRegular13(text: String? = nil) -> UILabel {
        let label = UILabel()
        label.text = text
        label.textColor = LagomStyle.Color.lagomGray
        label.font = LagomStyle.Font.regular13
        return label
    }
    
    static func lightGrayRegular13(text: String? = nil) -> UILabel {
        let label = UILabel()
        label.text = text
        label.textColor = LagomStyle.Color.lagomLightGray
        label.font = LagomStyle.Font.regular13
        return label
    }
}
