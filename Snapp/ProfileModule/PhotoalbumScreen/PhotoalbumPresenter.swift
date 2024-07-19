//
//  PhotoalbumPresenter.swift
//  Snapp
//
//  Created by Максим Жуин on 20.05.2024.
//

import UIKit
import FirebaseStorage

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
    let nsLock = NSLock()

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
                self?.nsLock.lock()
                self?.photoAlbum = convertedDictionary
                self?.nsLock.unlock()
                self?.view?.updateCollectionView()
            case .failure(let failure):
                self?.view?.showError(error: failure.localizedDescription)
            }
        }
    }

    func addImageToPhotoAlbum(image: UIImage) {
        let currentDate = Date()
        let dateFromatter = DateFormatter()
        dateFromatter.dateFormat = "dd MMM"
        let stringFromDate = dateFromatter.string(from: currentDate)
        let urlLink = Storage.storage().reference().child("users").child(mainUserID).child("PhotoAlbum").child(stringFromDate).child(image.description)
        FireStoreService.shared.saveImageIntoStorage(urlLink: urlLink, photo: image) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let success):
                FireStoreService.shared.saveImageIntoPhotoAlbum(image: success.absoluteString, user: self.mainUserID)
                self.fetchImageFromStorage()
            case .failure(let failure):
                self.view?.showError(error: failure.localizedDescription)
            }
        }
    }
}
