//
//  UserTable.swift
//  LagomStyle
//
//  Created by Minjae Kim on 7/8/24.
//

import Foundation

import RealmSwift

class Note: EmbeddedObject {
    @Persisted var contents: String
    @Persisted var regDate: Date
    @Persisted var updateDate: Date
}

class Folder: Object {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var name: String
    @Persisted var option: String
    @Persisted var regDate: Date
    
    // 1:N to many relationship
    @Persisted var detail: List<Basket>
    
    // 1:1 to one relationship
    @Persisted var note: Note?
}

class Basket: Object {
    @Persisted(primaryKey: true) var id: String
    @Persisted(indexed: true) var name: String
    @Persisted var mallName: String
    @Persisted var lowPrice: String
    @Persisted var webUrlString: String
    @Persisted var imageUrlString: String
    
    convenience init(id: String, name: String, mallName: String, lowPrice: String, webUrlString: String, imageUrlString: String) {
        self.init()
        self.id = id
        self.name = name
        self.mallName = mallName
        self.lowPrice = lowPrice
        self.webUrlString = webUrlString
        self.imageUrlString = imageUrlString
    }
}

class UserTable: Object {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var nickname: String
    @Persisted var proflieImageIndex: Int
    @Persisted var signupDate: Date
    @Persisted var recentSearchKeyword: Map<String, Date>
    
    convenience init(nickname: String, proflieImageIndex: Int, signupDate: Date) {
        self.init()
        self.nickname = nickname
        self.proflieImageIndex = proflieImageIndex
        self.signupDate = signupDate
    }
}
