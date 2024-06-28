//
//  ProfilePresenter.swift
//  Snapp
//
//  Created by Максим Жуин on 08.04.2024.
//

import UIKit
import FirebaseStorage
import FirebaseAuth


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
    init(view: ProfileViewProtocol, mainUser: FirebaseUser, mainUserID: String, firestoreService: FireStoreServiceProtocol)
}

final class ProfilePresenter: ProfilePresenterProtocol {

    weak var view: ProfileViewProtocol?
    var mainUser: FirebaseUser
    var firestoreService: FireStoreServiceProtocol
    var posts: [EachPost] = []
    var image: UIImage?
    let mainUserID: String
    var userStories: [UIImage]?
    var photoAlbum: [UIImage: [UIImage]?] = [:]
    let networkService = NetworkService()

    init(view: ProfileViewProtocol, mainUser: FirebaseUser, mainUserID: String, firestoreService: FireStoreServiceProtocol) {
        self.view = view
        self.mainUser = mainUser
        self.firestoreService = firestoreService
        self.mainUserID = mainUserID
        fetchAvatarImage()
    }

    func fetchAvatarImage()  {
        guard let urlLink = mainUser.image else { return }
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
        firestoreService.addSnapshotListenerToPosts(for: mainUserID) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let success):
                self.posts = []
                self.posts = success
                if let index = self.posts.firstIndex(where: { $0.isPinned == true }) {
                    let pinnedPost = self.posts[index]
                    self.posts.remove(at: index)
                    self.posts.insert(pinnedPost, at: 0)
                    print("Pinned array: \(self.posts)")
                    self.view?.updateData(data: self.posts)
                }
                self.view?.updateData(data: self.posts)
            case .failure(let failure):
                view?.showErrorAler(error: failure.localizedDescription)
            }
        }
    }

    func addPostToBookMarks(post: EachPost) {
        firestoreService.saveToBookMarks(user: mainUserID, post: post) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let savedPost):
                return
            case .failure(let error):
                view?.showErrorAler(error: error.localizedDescription)
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

        let storageLink = Storage.storage().reference().child("users").child(mainUserID).child("Stories").child(stringFromDate).child(image.description)
            firestoreService.saveImageIntoStorage(urlLink: storageLink, photo: image) { [weak self] result in
            switch result {
            case .success(let success):
                self?.networkService.fetchImage(string: success.absoluteString) { [weak self] result in
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

    func createMainPhotoAlbum(image: UIImage) {
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM"
        let stringFromDate = dateFormatter.string(from: date)

        let urlLink = Storage.storage().reference().child("users").child(mainUserID).child("PhotoAlbum").child(stringFromDate).child("CoverImage")
            firestoreService.saveImageIntoStorage(urlLink: urlLink, photo: image) { [weak self] result in
                switch result {
                case .success(let imageURL):
                    self?.networkService.fetchImage(string: imageURL.absoluteString) { [weak self] result in
                        guard let self else { return }
                        switch result {
                        case .success(let imageData):
                            guard let image = UIImage(data: imageData) else { return }
                            self.photoAlbum.updateValue(nil, forKey: image)
                        case .failure(let failure):
                            view?.showErrorAler(error: failure.localizedDescription)
                        }
                    }
                case .failure(let failure):
                    self?.view?.showErrorAler(error: failure.localizedDescription)
                }
            }
    }

    func addImageToPhotoAlbum(image: UIImage, state: ImageState) {
        switch state {
        case .storieImage:
            createStorie(image: image)
        case .photoImage:
print()
        }
    }

    func fetchSubsribers() {
        firestoreService.getUser(id: mainUserID) { [weak self] result in
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

    func incrementLikes(post: String) {
        guard let useID = mainUser.documentID else { return }
        firestoreService.incrementLikes(user: useID, mainUser: mainUserID, post: post)
    }

    func decrementLikes(post: String) {
        guard let userID = mainUser.documentID else { return }
        firestoreService.decrementLikes(user: userID, mainUser: mainUserID, post: post)
    }
}
