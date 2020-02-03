//
//  FlickerAPI.swift
//  TestFlickr
//
//  Created by Nikolay Lukyanchikov on 03.02.2020.
//  Copyright © 2020 Nikolay Lukyanchikov. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class FlickerAPI {
    
    static let url = URL(string: "https://api.flickr.com/services/rest/")!
    
    static private func getParamsFromPage(page: Int, perPage: Int) -> [String: Any] {
        
        let parameters = [
            "method" : "flickr.interestingness.getList",
            "api_key" : "91c7acc01e9b6f373348c7a71ec2983e",
            "sort": "relevance",
            "page": "\(page)",
            "per_page" : "\(perPage)",
            "format" : "json",
            "nojsoncallback" : "1",
            "extras": "url_q,url_z"
            ]
        
        return parameters
    }
    
    static func fetchFlickrPhotos(page: Int, perPage: Int, completion: (([FlickrPhoto]?) -> Void)? = nil) {
                
        Alamofire.request(FlickerAPI.url, method: .get, parameters: getParamsFromPage(page: page, perPage: perPage))
            .validate()
            .responseJSON { (response) -> Void in
                switch response.result {
                case .success:
                    guard let data = response.data, let json = try? JSON(data: data) else {
                        print("Error while parsing Flickr response")
                        completion?(nil)
                        return
                    }
                    
                    let photosJSON = json["photos"]["photo"]
                    let photos = photosJSON.arrayValue.compactMap { FlickrPhoto(json: $0) }
                    completion?(photos)
                    
                case .failure(let error):
                    print("Error while fetching photos: \(error.localizedDescription)")
                    completion?(nil)
                }
        }
    }

    
    
}
