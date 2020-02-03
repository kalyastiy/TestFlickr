//
//  Photo.swift
//  TestFlickr
//
//  Created by Nikolay Lukyanchikov on 03.02.2020.
//  Copyright © 2020 Nikolay Lukyanchikov. All rights reserved.
//

import Foundation
import SwiftyJSON

struct FlickrPhoto: Codable {
    
    var bigImageURL: String
    var smallImageURL: String
    
    init?(json: JSON) {
       
        guard let urlQ = json["url_q"].string, let urlZ = json["url_z"].string else {
                return nil
        }
        
        self.bigImageURL = urlZ
        self.smallImageURL = urlQ
    }

}
