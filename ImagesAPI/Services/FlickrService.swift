//
//  FlickrService.swift
//  ImagesAPI
//
//  Created by Fedya on 02.09.2020.
//  Copyright © 2020 Fedya. All rights reserved.
//

import Foundation
import ReactiveSwift
import RealmSwift

final class FlickrService {
    
    let localPhotos = MutableProperty<[Photo]>([])
    let database = Database()
    var notificationToken: NotificationToken?
    
    init() {
        setupObservers()
    }
    
    func searchPhoto(with text: String) {
        let api = API.Flickr.photoSearch(searchString: text)
        var components = URLComponents(string: api.path)
        components?.queryItems = api.params.map { (key, value) in
            URLQueryItem(name: key, value: value as? String)
        }
        let encodedQuery = components?.percentEncodedQuery?.replacingOccurrences(of: "+", with: "%2B")
        components?.percentEncodedQuery = encodedQuery
        guard let url = components?.url else { return }
        let request = URLRequest(url: url)
        
        let task = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            guard let data = data else {
                return }
            let photosResponse = try? JSONDecoder().decode(PhotoRequestResponse.self, from: data)
            guard let randomPhoto = photosResponse?.photos.photo.randomElement() else { return }
            let photo = Photo(id: Int(randomPhoto.id) ?? -1,
                              farm: randomPhoto.farm,
                              server: Int(randomPhoto.server) ?? -1,
                              secret: randomPhoto.secret,
                              searchText: text)
            self?.savePhoto(photo: photo)
            self?.saveImage(for: photo)
        }
        task.resume()
    }
    
    private func savePhoto(photo: Photo) {
        database.performWrite { realm in
            let primaryKey = RMPhoto.primaryKey()
            let rmPhoto = realm.create(RMPhoto.self, value: [primaryKey: photo.id], update: .all)
            rmPhoto.farm = photo.farm
            rmPhoto.secret = photo.secret
            rmPhoto.server = photo.server
            rmPhoto.searchText = photo.searchText
        }.start()
    }
    
    private func setupObservers() {
        database.perform({ [weak self] realm in
            self?.notificationToken = realm.objects(RMPhoto.self).observe({ (changes) in
                switch changes {
                case .initial(let collection), .update(let collection, _, _, _):
                    self?.localPhotos.value = collection.map { Photo(id: $0.id, farm: $0.farm, server: $0.server, secret: $0.secret, searchText: $0.searchText)}
                case .error(_):
                    break
                }
            })
        }).start()
    }
    
    private func saveImage(for photo: Photo) {
        guard let url = photo.imageURL else { return }
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            guard let data = data else { return }
            guard let directory = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) else {
                return
            }
            do {
                let fileUrl = directory.appendingPathComponent("\(photo.id).jpg")
                try data.write(to: fileUrl)
                self?.updateLocalPhotoImage(photo: photo, url: fileUrl)
                return
            } catch {
                print(error.localizedDescription)
            }
        }
        task.resume()
    }
    
    private func updateLocalPhotoImage(photo: Photo, url: URL) {
        database.performWrite { realm in
            let rmPhoto = realm.fetchOrCreate(RMPhoto.self, forPrimaryKey: photo.id)
            rmPhoto.imageUrl = url.absoluteString
        }.start()
    }
    
    deinit {
        notificationToken?.invalidate()
    }
}
