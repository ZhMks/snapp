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
    init(view: PhotoalbumViewProtocol, mainUserID: String)
}

final class PhotoalbumPresenter: PhotoalbumPresenterProtocol {
    
    weak var view: PhotoalbumViewProtocol?
    var photoAlbum: [String : [UIImage]?]?
    let mainUserID: String

    init(view: PhotoalbumViewProtocol, mainUserID: String) {
        self.view = view
        self.mainUserID = mainUserID
    }

    func fetchImageFromStorage() {
        FireStoreService.shared.fetchImagesFromStorage(user: mainUserID) { [weak self] result in
            switch result {
            case .success(let success):
                let sortedDictionary = success.sorted { $0.key > $1.key }
                let convertedDictionary = sortedDictionary.reduce(into: [String: [UIImage]?]()) { result, pair in
                                result[pair.key] = pair.value
                            }
                self?.photoAlbum = convertedDictionary
                self?.view?.updateCollectionView()
            case .failure(let failure):
                self?.view?.showError(error: failure.localizedDescription)
            }
        }
    }
}
