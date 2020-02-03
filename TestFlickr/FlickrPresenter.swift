//
//  FlickrPresenter.swift
//  TestFlickr
//
//  Created by Nikolay Lukyanchikov on 03.02.2020.
//  Copyright © 2020 Nikolay Lukyanchikov. All rights reserved.
//

import Foundation
import SwiftyJSON
import UIKit

class FlickrPresenter {
    
    private weak var view: FlickrViewProtocol?
    private let countPhotoUpload = 50 //дефолтное значение коллиичество фотографий на странице
    private var namberOfPage = 1 //номер загружаемой страницы
    private var loadingContent = false //используется для ограниичения повторной загрузке, когда предыдущая еще не закончилась

    var photos = [FlickrPhoto]()
        
    init(view: FlickrViewProtocol) {
        self.view = view
    }
    
    
}


extension FlickrPresenter: FlickrPresenterProtocol {
    
    func getFlickrPhotos() {
        
        if !loadingContent {
            
            loadingContent = true
            
            //если идет первая попытка загрузит фото, проверяем кеш на наличие сохраненных элементов
            if namberOfPage == 1 {
                if let data = loadData() {
                    photos = data
                    view?.updateContent()
                }
            }

            
            FlickerAPI.fetchFlickrPhotos(page: namberOfPage, perPage: countPhotoUpload) { [weak self] photos in
                guard let selfie = self else { return }
                if let photos = photos {
                    
                    if selfie.namberOfPage == 1 {
                        selfie.saveData(photos: photos)
                        
                        if photos.isEmpty {
                            selfie.photos += photos
                            selfie.view?.updateContent()

                        } else {
                            selfie.photos = photos
                            selfie.view?.updateContent()
                        }
                        
                    } else {
                        
                        //Создаем карту индексов новых картинок
                        let photosCount = selfie.photos.count

                        selfie.photos += photos
                        
                        let indexPaths = (photosCount..<selfie.photos.count).map{ index in
                            IndexPath(item: index, section: 0)
                        }
                        
                        DispatchQueue.main.async {
                            selfie.view?.insertItems(at: indexPaths)
                        }

                    }
                    
                    selfie.loadingContent = false
                    selfie.namberOfPage += 1
                }
            }

        }
    }
    
    func numberOfItems() -> Int {
        return photos.count
    }
    
    func smallImageURL(with index: Int) -> String {
        return photos[index].smallImageURL
    }
    
    
}


//Сохранение и извлечение данных
extension FlickrPresenter {
    
    static private let kUserDefaultsPhotosKey = "kPhotosKey"
    func loadData() -> [FlickrPhoto]? {
                
        let encoded = UserDefaults.standard.object(forKey: "player") as! Data
        return try? PropertyListDecoder().decode([FlickrPhoto].self, from: encoded)

    }

    func saveData(photos: [FlickrPhoto]) {
        try? UserDefaults.standard.set(PropertyListEncoder().encode(photos), forKey: "player")

    }
    
}
