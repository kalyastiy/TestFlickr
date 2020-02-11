//
//  FlickrViewProtocol.swift
//  TestFlickr
//
//  Created by Nikolay Lukyanchikov on 03.02.2020.
//  Copyright © 2020 Nikolay Lukyanchikov. All rights reserved.
//

import UIKit

protocol FlickrViewProtocol: AnyObject {
    
    func showMessage(title: String, body: String?)
    
    // Обновление UICollectionView
    func updateContent()
    func insertItems(at indexPaths:[IndexPath])
}

// Дефолтное значение UIAlertController
extension FlickrViewProtocol where Self: UIViewController {
    
    func showMessage(title: String, body: String?) {
        
        let alert = UIAlertController(title: title, message: body, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { action in
            self.dismiss(animated: true, completion: nil)
        }))
        
        present(alert, animated: true, completion: nil)
    }
}
