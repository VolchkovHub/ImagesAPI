//
//  RMPhoto.swift
//  ImagesAPI
//
//  Created by Fedya on 02.09.2020.
//  Copyright © 2020 Fedya. All rights reserved.
//

import Foundation
import RealmSwift

@objcMembers
final class RMPhoto: Object {
    override static func primaryKey() -> String? { return #keyPath(id) }
    
    dynamic var id: Int = -1
    dynamic var farm: Int = -1
    dynamic var server: Int = -1
    dynamic var secret: String = ""
    dynamic var searchText: String = ""
    dynamic var imageUrl: String = ""
}

extension Photo {
    init(_ object: RMPhoto) throws {
        
        self.init(id: object.id,
                  farm: object.farm,
                  server: object.server,
                  secret: object.secret,
                  searchText: object.searchText)
    }
}
