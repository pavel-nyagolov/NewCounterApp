//
//  FactoryStorage.swift
//  NewCounterApp
//
//  Created by Pavel on 10.04.23.
//

import Foundation
import RealmSwift

class FactoryStorage {
    static let realm = try! Realm(configuration: realmConfig)
    
    static var realmConfig: Realm.Configuration {
        var config = Realm.Configuration()
        config.deleteRealmIfMigrationNeeded = true
        config.schemaVersion = 1
        return config
    }
    
    static func addCount(_ count: CountModel) {
        FactoryStorage.realm.beginWrite()
        FactoryStorage.realm.add(count)
        try? FactoryStorage.realm.commitWrite()
        NotificationCenter.default.post(name: .updateData, object: nil)
    }
    
    static func deleteCount(_ count: CountModel) {
        FactoryStorage.realm.beginWrite()
        FactoryStorage.realm.delete(count)
        try? FactoryStorage.realm.commitWrite()
        NotificationCenter.default.post(name: .updateData, object: nil)
    }
    
    static func getCounts() -> [CountModel]? {
        return Array(FactoryStorage.realm.objects(CountModel.self).sorted(byKeyPath: "id", ascending: true))
    }
}
