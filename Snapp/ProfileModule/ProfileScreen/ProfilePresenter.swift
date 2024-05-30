//
//  ProfilePresenter.swift
//  Snapp
//
//  Created by Максим Жуин on 08.04.2024.
//

import UIKit
import FirebaseStorage


enum ImageState {
    case storieImage
    case photoImage
}

protocol ProfileViewProtocol: AnyObject {
    func showErrorAler(error: String)
    func updateAvatarImage(image: UIImage)
    func updateData(data: [EachPost])
    func updateStorie(stories: [UIImage]?)
    func updateAlbum(photo: [UIImage]?)
    func updateSubsribers()
    func updateSubscriptions()
    func updateTextData(user: FirebaseUser)
    func updateAvatrImageWithStorie()
}

protocol ProfilePresenterProtocol: AnyObject {
    init(view: ProfileViewProtocol, mainUser: FirebaseUser, userID: String, firestoreService: FireStoreServiceProtocol)
}

final class ProfilePresenter: ProfilePresenterProtocol {

    weak var view: ProfileViewProtocol?
    var mainUser: FirebaseUser
    var firestoreService: FireStoreServiceProtocol
    var posts: [EachPost] = []
    var image: UIImage?
    let userID: String
    var userStories: [UIImage]?
    var photoAlbum: [UIImage]? = []

    init(view: ProfileViewProtocol, mainUser: FirebaseUser, userID: String, firestoreService: FireStoreServiceProtocol) {
        self.view = view
        self.mainUser = mainUser
        self.firestoreService = firestoreService
        self.userID = userID
        fetchImage()
        fetchPhotoAlbum()
    }

    func fetchImage()  {
        guard let urlLink = mainUser.image else { return }
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

    func addListenerForPost() {
        guard let id = mainUser.documentID else { return }
        firestoreService.addSnapshotListenerToPosts(for: id) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let success):
                self.posts = []
                self.posts = success
                if let index = self.posts.firstIndex(where: { $0.isPinned == true }) {
                    let pinnedPost = self.posts[index]
                    self.posts.remove(at: index)
                    self.posts.insert(pinnedPost, at: 0)
                    self.view?.updateData(data: self.posts)
                }
                self.view?.updateData(data: self.posts)
            case .failure(let failure):
                view?.showErrorAler(error: failure.localizedDescription)
            }
        }
    }

    func pinPost( docID: String) {
        guard let user = mainUser.documentID else { return }
        firestoreService.pinPost(user: user, docID: docID)
    }

    func addListenerForUser() {
        guard let id = mainUser.documentID else { return }
        firestoreService.addSnapshotListenerToUser(for: id) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let success):
                self.mainUser = success
                self.view?.updateSubsribers()
                self.view?.updateSubscriptions()
                self.view?.updateStorie(stories: self.userStories)
                self.view?.updateTextData(user: self.mainUser)
            case .failure(let failure):
                view?.showErrorAler(error: failure.localizedDescription)
            }
        }
    }

    func createStorie(image: UIImage) {
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM"
        let stringFromDate = dateFormatter.string(from: date)
        
        let networkService = NetworkService()

        let storageLink = Storage.storage().reference().child("users").child(userID).child("Stories").child(stringFromDate).child(image.description)
            firestoreService.saveImageIntoStorage(urlLink: storageLink, photo: image) { [weak self] result in
            switch result {
            case .success(let success):
                networkService.fetchImage(string: success.absoluteString) { [weak self] result in
                    guard let self else { return }
                    switch result {
                    case .success(let data):
                        guard let storieImage = UIImage(data: data) else { return }
                        self.userStories?.append(storieImage)
                        firestoreService.changeData(id: mainUser.documentID!, text: success.absoluteString, state: .storie)
                        self.view?.updateAvatrImageWithStorie()
                        
                    case .failure(let failure):
                        self.view?.showErrorAler(error: failure.localizedDescription)
                    }
                }
            case .failure(let failure):
                self?.view?.showErrorAler(error: failure.localizedDescription)
            }
        }
    }

    func addPhotoToAlbum(image: UIImage, state: ImageState) {
        switch state {
        case .storieImage:
            createStorie(image: image)
        case .photoImage:
            let networkService = NetworkService()
            let urlLink = Storage.storage().reference().child("users").child(userID).child("PhotoAlbum").child(image.description)
            firestoreService.saveImageIntoStorage(urlLink: urlLink, photo: image) { [weak self] result in
                guard let self else { return }
                switch result {
                case .success(let url):
                    firestoreService.saveImageIntoPhotoAlbum(image: url.absoluteString, user: userID)
                    networkService.fetchImage(string: url.absoluteString) { [weak self] result in
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
                    self.view?.showErrorAler(error: failure.localizedDescription)
                }
            }
        }
    }

    func fetchPhotoAlbum() {
        self.photoAlbum = []
        let networkService = NetworkService()
        let dispatchGroup = DispatchGroup()
        for link in mainUser.photoAlbum {
            dispatchGroup.enter()
            networkService.fetchImage(string: link) { [weak self] result in
                switch result {
                case .success(let data):
                    guard let image = UIImage(data: data) else { return }
                    self?.photoAlbum?.append(image)
                case .failure(let failure):
                    self?.view?.showErrorAler(error: failure.localizedDescription)
                }
                dispatchGroup.leave()
            }
        }
        dispatchGroup.notify(queue: .main) { [weak self] in
            guard let photoAlbum = self?.photoAlbum else { return }
            self?.view?.updateAlbum(photo: photoAlbum)
        }
    }

    func fetchSubsribers() {
        firestoreService.getUser(id: userID) { [weak self] result in
            switch result {
            case .success(let success):
                self?.mainUser = success
                self?.view?.updateSubsribers()
            case .failure(let failure):
                self?.view?.showErrorAler(error: failure.localizedDescription)
            }
        }
    }

    func removePostListener() {
        firestoreService.removeListenerForPosts()
    }

    func removeUserListener() {
        firestoreService.removeListenerForUser()
    }
}
