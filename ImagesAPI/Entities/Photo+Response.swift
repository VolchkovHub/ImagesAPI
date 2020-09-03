//
//  Photo+Response.swift
//  ImagesAPI
//
//  Created by Fedya on 02.09.2020.
//  Copyright © 2020 Fedya. All rights reserved.
//

import Foundation

extension Photo {
    struct Response: Decodable {
        var id: String
        var farm: Int
        var server: String
        var secret: String
        
    }
    
    init(from response: Response) {
        self.id = Int(response.id) ?? -1
        self.farm = response.farm
        self.server = Int(response.server) ?? -1
        self.secret = response.secret
        self.searchText = ""
    }
 }

struct PhotoArrayResponse: Decodable {
    var photo: [Photo.Response]
}

struct PhotoRequestResponse: Decodable {
    var photos: PhotoArrayResponse
}
