//
//  ImagesVM.swift
//  ImagesAPI
//
//  Created by Fedya on 02.09.2020.
//  Copyright © 2020 Fedya. All rights reserved.
//

import Foundation
import ReactiveSwift

final class ImagesVM {
    
    private let flickrService = FlickrService()
    
    let localPhotos = MutableProperty<[Photo]>([])
    
    init() {
        setupObservers()
    }
    
    func searchPhoto(with text: String) {
        flickrService.searchPhoto(with: text)
    }
    
    private func setupObservers() {
        flickrService.localPhotos.producer.startWithValues { [weak self] in
            self?.localPhotos.value = $0.reversed()
        }
    }
}
