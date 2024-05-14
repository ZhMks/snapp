//
//  ProfilePresenter.swift
//  Snapp
//
//  Created by Максим Жуин on 08.04.2024.
//

import UIKit
import FirebaseStorage


protocol ProfileViewProtocol: AnyObject {
    func showErrorAler(error: String)
    func updateAvatarImage(image: UIImage)
    func updateData(data: [MainPost])
    func updateStorie(stories: [UIImage]?)
    func updateAlbum(photo: [UIImage]?)
}

protocol ProfilePresenterProtocol: AnyObject {
    init(view: ProfileViewProtocol, mainUser: FirebaseUser, userID: String, firestoreService: FireStoreServiceProtocol)
}

final class ProfilePresenter: ProfilePresenterProtocol {

    weak var view: ProfileViewProtocol?
    var mainUser: FirebaseUser
    var firestoreService: FireStoreServiceProtocol
    var posts: [MainPost] = []
    var image: UIImage?
    let userID: String
    var userStories: [UIImage]?
    var photoAlbum: [UIImage]?

    init(view: ProfileViewProtocol, mainUser: FirebaseUser, userID: String, firestoreService: FireStoreServiceProtocol) {
        self.view = view
        self.mainUser = mainUser
        self.firestoreService = firestoreService
        self.userID = userID
        fetchImage()
        fetchPosts()
    }

    func fetchImage()  {
        let urlLink = mainUser.image
        let networkService = NetworkService()
        networkService.fetchImage(string: urlLink) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let data):
                guard let image = UIImage(data: data) else { return }
                self.image = image
                view?.updateAvatarImage(image: image)
            case .failure(let failure):
                view?.showErrorAler(error: failure.localizedDescription)
            }
        }
    }

    func fetchPosts() {
        firestoreService.getPosts(sub: userID) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let success):
                self.posts = success
                print(self.posts)
                view?.updateData(data: self.posts)
            case .failure(let failure):
                print()
            }
        }
    }

    func createStorie(image: UIImage) {
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        let stringFromDate = dateFormatter.string(from: date)
        let networkService = NetworkService()

        let urlLink = Storage.storage().reference().child("user").child(userID).child("Stories").child(stringFromDate)
        firestoreService.saveImageIntoStorage(urlLink: urlLink, photo: image) { [weak self] result in
            switch result {
            case .success(let success):
                networkService.fetchImage(string: success.absoluteString) { [weak self] result in
                    switch result {
                    case .success(let success):
                        guard let storieImage = UIImage(data: success) else { return }
                        self?.userStories?.append(storieImage)
                        self?.view?.updateStorie(stories: self?.userStories)
                    case .failure(let failure):
                        self?.view?.showErrorAler(error: failure.localizedDescription)
                    }
                }
            case .failure(let failure):
                self?.view?.showErrorAler(error: failure.localizedDescription)
            }
        }
    }

    func addPhotoToAlbum(image: UIImage) {
        let networkService = NetworkService()
        let urlLink = Storage.storage().reference().child("user").child(userID).child("PhotoAlbum")
        firestoreService.saveImageIntoStorage(urlLink: urlLink, photo: image) { [weak self] result in
            switch result {
            case .success(let success):
                networkService.fetchImage(string: success.absoluteString) { [weak self] result in
                    switch result {
                    case .success(let success):
                        guard let albumImage = UIImage(data: success) else { return }
                        self?.photoAlbum?.append(albumImage)
                        self?.view?.updateAlbum(photo: self?.photoAlbum)
                    case .failure(let failure):
                        self?.view?.showErrorAler(error: failure.localizedDescription)
                    }
                }
            case .failure(let failure):
                self?.view?.showErrorAler(error: failure.localizedDescription)
            }
        }
    }
}
