//
//  String+.swift
//  LagomStyle
//
//  Created by Minjae Kim on 6/13/24.
//

import UIKit

extension String {
    
    // MARK: 검색된 결과에 따른 해당 키워드 Text Color 변경
    func changedSearchTextColor(_ text: String?) -> NSAttributedString {
        guard let text, !text.isEmpty else {
            return NSAttributedString(string: self)
        }
        
        let attributedString = NSMutableAttributedString(string: self)
        let highlightBoldAttribute = [NSAttributedString.Key.backgroundColor: LagomStyle.AssetColor.lagomPrimaryColor, NSAttributedString.Key.foregroundColor: LagomStyle.AssetColor.lagomWhite, NSAttributedString.Key.font: LagomStyle.SystemFont.black14]
        attributedString.addAttributes(highlightBoldAttribute,
                                      range: (self as NSString).range(of: text, options: .caseInsensitive))
        
        return attributedString
    }
    
    // MARK: String Data를 URL 데이터타입으로 변환
    var stringToURL: URL? {
        return URL(string: self)
    }
    
    // MARK: API 요청 결과 String Data에 Markup Data가 포함되어 삭제 필요
    var removeHtmlTag: String {
        return self
            .replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression) // tag 삭제
    }
}
