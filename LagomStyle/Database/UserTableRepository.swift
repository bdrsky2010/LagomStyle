//
//  UserTableRepository.swift
//  LagomStyle
//
//  Created by Minjae Kim on 7/8/24.
//

import Foundation

import RealmSwift

final class UserTableRepository {
    private let realm = try! Realm()
    
    func createUser(_ user: UserTable) {
        do {
            try realm.write {
                realm.add(user)
                print("Realm Create Succeed")
            }
        } catch {
            print("Realm Error")
        }
    }
    
    func fetchUser() -> Results<UserTable> {
        let user = realm.objects(UserTable.self)
        return user
    }
    
    func updateItem(value: [String: Any]) {
        do {
            try realm.write {
                realm.create(UserTable.self, value: value, update: .modified)
                print("Realm Update Succeed")
            }
        } catch {
            print("Realm Error")
        }
    }
    
    func deleteItem(_ user: UserTable) {
        do {
            try realm.write {
                realm.delete(user)
            }
        } catch {
            print("Realm Error")
        }
    }
    
    func printSchemaVersion() {
        // Realm Schema Version 확인
        do {
            let version = try schemaVersionAtURL(realm.configuration.fileURL!)
            print("Realm Schema Version: \(version)")
        } catch {
            print(error)
        }
    }
    
    func printDatebaseURL() {
        print(realm.configuration.fileURL!)
    }
}
