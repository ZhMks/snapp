//
//  PhotoalbumPresenter.swift
//  Snapp
//
//  Created by Максим Жуин on 20.05.2024.
//

import UIKit

protocol PhotoalbumViewProtocol: AnyObject {
    func showError(error: String)
    func updateCollectionView()
}

protocol PhotoalbumPresenterProtocol: AnyObject {
    init(view: PhotoalbumViewProtocol, photoAlbum: [UIImage : [UIImage]?])
}

final class PhotoalbumPresenter: PhotoalbumPresenterProtocol {
    
    weak var view: PhotoalbumViewProtocol?
    var photoAlbum: [UIImage : [UIImage]?]

    init(view: PhotoalbumViewProtocol, photoAlbum: [UIImage : [UIImage]?]) {
        self.view = view
        self.photoAlbum = photoAlbum
    }
}
