//
//  Date+.swift
//  LagomStyle
//
//  Created by Minjae Kim on 6/17/24.
//

import Foundation

extension Date {
    static var convertString: String {
        let dateFormmater = DateFormatter()
        dateFormmater.locale = Locale(identifier: "ko_KR")
        dateFormmater.dateFormat = "yyyy. MM. dd"
        let convertString = dateFormmater.string(from: Date())
        return convertString
    }
}
