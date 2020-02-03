//
//  ImageCollectionViewCell.swift
//  TestFlickr
//
//  Created by Nikolay Lukyanchikov on 03.02.2020.
//  Copyright © 2020 Nikolay Lukyanchikov. All rights reserved.
//

import UIKit
import Kingfisher

class ImageCollectionViewCell: UICollectionViewCell {
    @IBOutlet var imageView: UIImageView!
    
    var imageURL: String? {
        didSet {
            if let imageURL = imageURL, let url = URL(string: imageURL) {
                imageView.kf.setImage(with: url)
            } else {
                imageView.image = nil
                imageView.kf.cancelDownloadTask()
            }
        }
    }
}

