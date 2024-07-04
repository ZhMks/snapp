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
    func updateAlbum(photo: [UIImage]?)
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
    var photoAlbum: [String: [UIImage]?] = [:]
    let networkService = NetworkService()
    var currentDate: String?

    init(view: ProfileViewProtocol, mainUser: FirebaseUser, mainUserID: String) {
        self.view = view
        self.mainUser = mainUser
        self.mainUserID = mainUserID
        addListenerForPost()
        addListenerForUser()
        getCurrentDate()
        fetchPhotoAlbum()
    }

    deinit {
        removePostListener()
        removeUserListener()
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

    func addListenerForPost() {
        posts = []
        FireStoreService.shared.addSnapshotListenerToPosts(for: mainUserID) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let success):
                posts = success
                if let index = self.posts.firstIndex(where: { $0.isPinned == true }) {
                    let pinnedPost = self.posts[index]
                    posts.remove(at: index)
                    posts.insert(pinnedPost, at: 0)
                    view?.updateData(data: self.posts)
                }
                self.view?.updateData(data: self.posts)
            case .failure(let failure):
                view?.showErrorAler(error: failure.localizedDescription)
            }
        }
    }

    func addPostToBookMarks(post: EachPost) {
        FireStoreService.shared.saveToBookMarks(user: mainUserID, post: post) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(_):
                return
            case .failure(let error):
                view?.showErrorAler(error: error.localizedDescription)
            }
        }
    }

    func pinPost( docID: String) {
        guard let user = mainUser.documentID else { return }
        FireStoreService.shared.pinPost(user: user, docID: docID)
    }

    func addListenerForUser() {
        guard let id = mainUser.documentID else { return }
        FireStoreService.shared.addSnapshotListenerToUser(for: id) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let success):
                mainUser = success
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
                FireStoreService.shared.changeData(id: mainUser.documentID!, text: success.absoluteString, state: .storie)
            case .failure(let failure):
                view?.showErrorAler(error: failure.localizedDescription)
            }
        }
    }

    func addImageToPhotoAlbum(image: UIImage, state: ImageState) {
        switch state {
        case .storieImage:
            createStorie(image: image)
        case .photoImage:
            let link = Storage.storage().reference().child("users").child(mainUserID).child("PhotoAlbum").child(currentDate!)
            FireStoreService.shared.saveImageIntoStorage(urlLink: link, photo: image) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let urlLink):
                    networkService.fetchImage(string: urlLink.absoluteString) { [weak self] result in
                        guard let self else { return }
                        switch result {
                        case .success(let image):
                            if photoAlbum.keys.isEmpty {
                                photoAlbum.updateValue([image], forKey: currentDate!)
                            } else {
                                if var imagesArray = photoAlbum[currentDate!] {
                                    imagesArray?.append(image)
                                    photoAlbum[currentDate!] = imagesArray
                                }
                            }
                        case .failure(_):
                            print()
                        }
                    }
                case .failure(let failure):
                    view?.showErrorAler(error: failure.localizedDescription)
                }
            }
        }
    }

    func fetchSubsribers() {
        FireStoreService.shared.getUser(id: mainUserID) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let success):
                mainUser = success
                view?.updateSubsribers()
            case .failure(let failure):
                view?.showErrorAler(error: failure.localizedDescription)
            }
        }
    }

    func fetchPhotoAlbum() {
        let link = Storage.storage().reference().child("users").child(mainUserID).child("PhotoAlbum")
        FireStoreService.shared.fetchImagesFromStorage(link: link)
    }

    func removePostListener() {
        FireStoreService.shared.removeListenerForPosts()
    }

    func removeUserListener() {
        FireStoreService.shared.removeListenerForUser()
    }

    func incrementLikes(post: String) {
        guard let useID = mainUser.documentID else { return }
        FireStoreService.shared.incrementLikes(user: useID, mainUser: mainUserID, post: post)
    }

    func decrementLikes(post: String) {
        guard let userID = mainUser.documentID else { return }
        FireStoreService.shared.decrementLikes(user: userID, mainUser: mainUserID, post: post)
    }
}
