//
//  ImageTVC.swift
//  ImagesAPI
//
//  Created by Fedya on 01.09.2020.
//  Copyright © 2020 Fedya. All rights reserved.
//

import UIKit

class ImageTVC: UITableViewCell {
    
    @IBOutlet weak var searchLabel: UILabel!
    @IBOutlet weak var searchImageView: UIImageView!
    
    func configure(with photo: Photo) {
        searchLabel.text = photo.searchText
        loadImage(for: photo)
    }
    
    private func loadImage(for photo: Photo) {
        let documentDirectory = FileManager.SearchPathDirectory.documentDirectory
        let userDomainMask = FileManager.SearchPathDomainMask.userDomainMask
        let paths = NSSearchPathForDirectoriesInDomains(documentDirectory, userDomainMask, true)
        if let dirPath = paths.first {
           let imageURL = URL(fileURLWithPath: dirPath).appendingPathComponent("\(photo.id).jpg")
            searchImageView.image = UIImage(contentsOfFile: imageURL.path)
        }
    }
    
    override func prepareForReuse() {
        searchImageView.image = nil
    }
}
