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
    
    let localPhotos = MutableProperty<[Photo]>([])
    var errorsOutput: Signal<Error, Never> {
        return errorsPipe.output
    }
    
    private let errorsPipe = Signal<Error, Never>.pipe()
    private let flickrService = FlickrService()
    
    init() {
        setupObservers()
    }
    
    func searchPhoto(with text: String) {
        flickrService.searchPhoto(with: text, completion: { [errorsPipe] result in
            switch result {
            case .failure(let error):
                errorsPipe.input.send(value: error)
            }
        })
    }
    
    private func setupObservers() {
        flickrService.localPhotos.producer.startWithValues { [weak self] in
            self?.localPhotos.value = $0.reversed()
        }
    }
}
