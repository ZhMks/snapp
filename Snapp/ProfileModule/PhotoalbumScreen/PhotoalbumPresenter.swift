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
    init(view: PhotoalbumViewProtocol, user: FirebaseUser, firestoreService: FireStoreServiceProtocol)
}

final class PhotoalbumPresenter: PhotoalbumPresenterProtocol {
    weak var view: PhotoalbumViewProtocol?
    let user: FirebaseUser
    let firestoreService: FireStoreServiceProtocol
    var photoAlbum: [UIImage] = []

    init(view: PhotoalbumViewProtocol, user: FirebaseUser, firestoreService: FireStoreServiceProtocol) {
        self.view = view
        self.user = user
        self.firestoreService = firestoreService
        fetchPhotoalbum()
    }

    func fetchPhotoalbum() {
        let networkService = NetworkService()
        let dispatchGroup = DispatchGroup()
        for link in user.photoAlbum {
            dispatchGroup.enter()
            networkService.fetchImage(string: link) { [weak self] result in
                guard let self else { return }
                switch result {
                case .success(let data):
                    guard let image = UIImage(data: data) else { return }
                    photoAlbum.append(image)
                case .failure(let failure):
                    view?.showError(error: failure.localizedDescription)
                }
                dispatchGroup.leave()
            }
        }
        dispatchGroup.notify(queue: .main) { [weak self] in
            guard let self else { return }
            self.view?.updateCollectionView()
        }
    }
}
