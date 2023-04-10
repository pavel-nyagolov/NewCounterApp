//
//  CountModel.swift
//  NewCounterApp
//
//  Created by Pavel on 10.04.23.
//

import Foundation
import RealmSwift

class CountModel: Object, ObjectKeyIdentifiable, Codable {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var title: String
    @Persisted var count: Int = 0
}
