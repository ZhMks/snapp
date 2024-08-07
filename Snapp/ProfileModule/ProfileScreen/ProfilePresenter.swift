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
    func updateAlbum()
    func updateSubsribers()
    func updateSubscriptions()
    func updateTextData(user: FirebaseUser)
}

protocol ProfilePresenterProtocol: AnyObject {
    init(view: ProfileViewProtocol, mainUser: FirebaseUser, mainUserID: String)
}

final class ProfilePresenter: ProfilePresenterProtocol {

    weak var view: ProfileViewProtocol?
    var mainUser: FirebaseUser
    var posts: [EachPost] = []
    var avatarImage: UIImage?
    let mainUserID: String
    var photoAlbum: [UIImage]?
    let networkService = NetworkService()
    var currentDate: String?
    var photoAlbumDictionary: [String: [UIImage]?]?
    let nsLock = NSLock()

    init(view: ProfileViewProtocol, mainUser: FirebaseUser, mainUserID: String) {
        self.view = view
        self.mainUser = mainUser
        self.mainUserID = mainUserID
        getCurrentDate()
        fetchAvatarImage()
    }

    func fetchAvatarImage()  {
        guard let urlLink = mainUser.image else { return }
        networkService.fetchImage(string: urlLink) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let image):
                avatarImage = image
                view?.updateAvatarImage(image: image)
            case .failure(let failure):
                view?.showErrorAler(error: failure.localizedDescription)
            }
        }
    }

    private func getCurrentDate() {
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM"
        let stringFromDate = dateFormatter.string(from: date)

        self.currentDate = stringFromDate
    }

    func addToFavourites(post: EachPost, user: FirebaseUser) {
        FireStoreService.shared.saveIntoFavourites(post: post, for: mainUserID, user: user.documentID!) { [weak self] result in
            switch result {
            case .success(let success):
                if success {
                    return
                } else {
                    self?.view?.showErrorAler(error: "Пост уже существует")
                }
            case .failure(let failure):
                self?.view?.showErrorAler(error: failure.localizedDescription)
            }
        }
    }

    func removeFromFavourites(post: EachPost, user: FirebaseUser) {
        FireStoreService.shared.removeFromFavourites(user: mainUserID, post: post)
    }

    func addListenerForPost() {
        FireStoreService.shared.addSnapshotListenerToPosts(for: mainUserID) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let success):
                let convertedPosts = success.sorted { $0.date > $1.date }
                posts = convertedPosts
                if let index = self.posts.firstIndex(where: { $0.isPinned == true }) {
                    nsLock.lock()
                    let pinnedPost = self.posts[index]
                    posts.remove(at: index)
                    posts.insert(pinnedPost, at: 0)
                    nsLock.unlock()
                    view?.updateData(data: self.posts)
                }
                nsLock.lock()
                self.view?.updateData(data: self.posts)
                nsLock.unlock()
            case .failure(let failure):
                view?.showErrorAler(error: failure.localizedDescription)
            }
        }
    }

    func addPostToBookMarks(post: EachPost, user: FirebaseUser) {
        FireStoreService.shared.saveToBookMarks(mainUser: mainUserID, user: user.documentID!, post: post) { [weak self] result in
            switch result {
            case .success(let success):
                if success {
                    return
                } else {
                    self?.view?.showErrorAler(error: "Пост уже существует")
                }
            case .failure(let failure):
                self?.view?.showErrorAler(error: failure.localizedDescription)
            }
        }
    }

    func pinPost( docID: String) {
        FireStoreService.shared.pinPost(user: mainUserID, docID: docID)
    }

    func addListenerForUser() {
        FireStoreService.shared.addSnapshotListenerToUser(for: mainUserID) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let success):
                mainUser = success
                fetchPhotoAlbum()
                view?.updateSubsribers()
                view?.updateSubscriptions()
                view?.updateTextData(user: self.mainUser)
            case .failure(let failure):
                view?.showErrorAler(error: failure.localizedDescription)
            }
        }
    }

    func createStorie(image: UIImage) {
        let storageLink = Storage.storage().reference().child("users").child(mainUserID).child("Stories").child(currentDate!).child(image.description)
        FireStoreService.shared.saveImageIntoStorage(urlLink: storageLink, photo: image) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let success):
                FireStoreService.shared.changeData(id: mainUserID, text: success.absoluteString, state: .storie)
            case .failure(let failure):
                view?.showErrorAler(error: failure.localizedDescription)
            }
        }
    }

    func saveImageIntoPhotoAlbum(image: UIImage, state: ImageState) {
        switch state {
        case .storieImage:
            createStorie(image: image)
        case .photoImage:
            let link = Storage.storage().reference().child("users").child(mainUserID).child("PhotoAlbum").child(currentDate!).child(image.description)
            FireStoreService.shared.saveImageIntoStorage(urlLink: link, photo: image) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let urlLink):
                    FireStoreService.shared.saveImageIntoPhotoAlbum(image: urlLink.absoluteString, user: mainUserID)
                case .failure(let failure):
                    view?.showErrorAler(error: failure.localizedDescription)
                }
            }
        }
    }

    func fetchPhotoAlbum() {
        self.photoAlbum = []
        let dispatchGroup = DispatchGroup()
        let networkService = NetworkService()
        for imageUrl in mainUser.photoAlbum {
            dispatchGroup.enter()
            networkService.fetchImage(string: imageUrl) { [weak self] result in
                switch result {
                case .success(let image):
                    self?.photoAlbum?.append(image)
                case .failure(let failure):
                    self?.view?.showErrorAler(error: failure.localizedDescription)
                }
                dispatchGroup.leave()
            }
        }

        dispatchGroup.notify(queue: .main) { [weak self] in
            self?.view?.updateAlbum()
        }

    }

    func fetchSubsribers() {
        FireStoreService.shared.getUser(id: mainUserID) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let success):
                nsLock.lock()
                mainUser = success
                nsLock.unlock()
                view?.updateSubsribers()
            case .failure(let failure):
                view?.showErrorAler(error: failure.localizedDescription)
            }
        }
    }

    func removePostListener() {
        FireStoreService.shared.removeListenerForPosts()
    }

    func removeUserListener() {
        FireStoreService.shared.removeListenerForUser()
    }

    func incrementLikes(post: EachPost, user: FirebaseUser) {
        guard let postID = post.documentID else { return }
        FireStoreService.shared.incrementLikesForPost(user: user.documentID!, mainUser: mainUserID, post: postID)
    }

    func decrementLikes(post: EachPost, user: FirebaseUser) {
        guard let postID = post.documentID else { return }
        FireStoreService.shared.decrementLikesForPost(user: user.documentID!, mainUser: mainUserID, post: postID)
    }
}
