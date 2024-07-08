//
//  UserTableRepository.swift
//  LagomStyle
//
//  Created by Minjae Kim on 7/8/24.
//

import Foundation

import RealmSwift

final class RealmRepository {
    private let realm = try! Realm()
    
    func createItem<T: Object>(_ item: T) {
        do {
            try realm.write {
                realm.add(item)
                print("Realm Create Succeed")
            }
        } catch {
            print("Realm Error")
        }
    }
    
    func fetchItem<T: Object>(of type: T.Type) -> Results<T> {
        let user = realm.objects(type.self)
        return user
    }
    
    func updateItem<T: Object>(of type: T.Type, value: [String: Any]) {
        do {
            try realm.write {
                realm.create(type.self, value: value, update: .modified)
                print("Realm Update Succeed")
            }
        } catch {
            print("Realm Error")
        }
    }
    
    func updateItem(completionHandler: () -> Void) {
        do {
            try realm.write {
                completionHandler()
                print("Realm Update Succeed")
            }
        } catch {
            print("Realm Error")
        }
    }
    
    func deleteItem<T: Object>(_ item: T) {
        do {
            try realm.write {
                if let folder = item as? Folder {
                    print("폴더 삭제")
                    realm.delete(folder.detail)
                }
                realm.delete(item)
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
