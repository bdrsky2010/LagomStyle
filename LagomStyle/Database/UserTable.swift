//
//  UserTable.swift
//  LagomStyle
//
//  Created by Minjae Kim on 7/8/24.
//

import Foundation

import RealmSwift

class UserTable: Object {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var nickname: String
    @Persisted var proflieImageIndex: Int
    @Persisted var signupDate: Date
    
    convenience init(nickname: String, proflieImageIndex: Int, signupDate: Date) {
        self.init()
        self.nickname = nickname
        self.proflieImageIndex = proflieImageIndex
        self.signupDate = signupDate
    }
}
