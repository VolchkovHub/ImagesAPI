//
//  FlickrAPI.swift
//  ImagesAPI
//
//  Created by Fedya on 02.09.2020.
//  Copyright © 2020 Fedya. All rights reserved.
//

import Foundation

enum API {}

extension API {
    enum Flickr {
        case photoSearch(searchString: String)
        
        private var baseURL: URL {
            return URL(string: "https://www.flickr.com/")!
        }
        
        private var apiKey: String {
            return "37c06cc593fcac8c05054dda6fa95ffb"
        }
        
        var path: String {
            switch self {
            case .photoSearch:
                return baseURL.absoluteString + "services/rest/"
            }
        }
        
        var params: [String: Any] {
            switch self {
            case .photoSearch(let searchString):
                return ["method": "flickr.photos.search",
                        "text": searchString,
                        "api_key": apiKey,
                        "format": "json",
                        "nojsoncallback": "1"]
            }
        }
    }
}
