//
//  Realm+Extension.swift
//  ImagesAPI
//
//  Created by Fedya on 02.09.2020.
//  Copyright © 2020 Fedya. All rights reserved.
//

import RealmSwift

extension Realm {
    func objectsForPrimaryKeys<T: Object>(type: T.Type,
                                          keys: [Any]) -> Results<T> {
        guard let primaryKey = T.primaryKey() else {
            return objects(type)
        }
        return objects(type).filter("\(primaryKey) IN %@", keys)
    }

    func fetchOrCreate<T: Object, Key>(_ type: T.Type,
                                       forPrimaryKey key: Key) -> T {
        guard let primaryKey = T.primaryKey() else { return T() }
        return create(type, value: [primaryKey: key], update: .all)
    }
}
