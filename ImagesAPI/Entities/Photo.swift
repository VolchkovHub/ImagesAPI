//
//  Photo.swift
//  ImagesAPI
//
//  Created by Fedya on 02.09.2020.
//  Copyright © 2020 Fedya. All rights reserved.
//

import Foundation

struct Photo {
    var id: Int
    var farm: Int
    var server: Int
    var secret: String
    var searchText: String
    
    var imageURL: URL? {
        URL(string: "https://farm\(farm).staticflickr.com/\(server)/\(id)_\(secret).jpg")
    }
}
