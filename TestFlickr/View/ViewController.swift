//
//  ViewController.swift
//  TestFlickr
//
//  Created by Nikolay Lukyanchikov on 03.02.2020.
//  Copyright © 2020 Nikolay Lukyanchikov. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    var presenter: FlickrPresenterProtocol!

    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.startAnimating()
        presenter = FlickrPresenter(view: self)
        presenter.getFlickrPhotos()
    }    


    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        collectionView.collectionViewLayout.invalidateLayout()
        
        if let topVisibleItemIndexPath = collectionView.indexPathsForVisibleItems.min() {
            coordinator.animate(alongsideTransition: { [weak collectionView] context in
            collectionView?.scrollToItem(at: topVisibleItemIndexPath,
                                         at: .top,
                                         animated: true)},
                                completion: nil)
        }
    }
    
    open func scrollViewDidScroll(_ scrollView: UIScrollView) {

        let loadingMoreContentOffset: CGFloat = 200
        let height = scrollView.frame.size.height
        let contentYoffset = scrollView.contentOffset.y
        let distanceFromBottom = scrollView.contentSize.height - contentYoffset
        if distanceFromBottom < height + loadingMoreContentOffset {
            
            activityIndicator.startAnimating()
            presenter.getFlickrPhotos()
        }
    }

}




// MARK: - UICollectionViewDataSource
extension ViewController: UICollectionViewDataSource {
    
    static let CellId = "itemCell"
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter.numberOfItems()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Self.CellId,
                                                      for: indexPath) as! ImageCollectionViewCell
        cell.imageURL = presenter.smallImageURL(with: indexPath.row)
        return cell
    }
    
}
// MARK: - UICollectionViewDelegateFlowLayout
extension ViewController: UICollectionViewDelegateFlowLayout {
    var interItemSpacing: CGFloat {
        return 4.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        // отображение 3-х фото на экране
        let width = collectionView.bounds.width/3 - 2 * interItemSpacing
        
        // 4:3 ratio
        let height = width * 3 / 4
        
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return interItemSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 4.0, left: 0.0, bottom: 4.0, right: 0.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 50.0)
    }
}

// MARK: - FlickrViewProtocol
extension ViewController: FlickrViewProtocol {

    func updateContent() {
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
            self.collectionView.reloadData()
        }
    }

    func insertItems(at indexPaths:[IndexPath]) {
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
            self.collectionView.insertItems(at: indexPaths)
        }
    }
}
