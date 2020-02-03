//
//  FlickrPresenterProtocol.swift
//  TestFlickr
//
//  Created by Nikolay Lukyanchikov on 03.02.2020.
//  Copyright © 2020 Nikolay Lukyanchikov. All rights reserved.
//

import UIKit

protocol FlickrPresenterProtocol {
    
    func getFlickrPhotos()
    func numberOfItems() -> Int
    func smallImageURL(with index: Int) -> String

}
