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

    func addToFavourites(post: EachPost) {
        FireStoreService.shared.saveIntoFavourites(post: post, for: mainUserID)
    }

    func removeFromFavourites(post: EachPost) {
        FireStoreService.shared.removeFromFavourites(user: mainUserID, post: post)
    }

    func addListenerForPost() {
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
                    print("URL LINK OF IMAGE: \(urlLink.absoluteString)")
                case .failure(let failure):
                    view?.showErrorAler(error: failure.localizedDescription)
                }
            }
        }
    }

    func fetchPhotoAlbum() {
        print(mainUser.photoAlbum.count)
        
        self.photoAlbum = []
        let dispatchGroup = DispatchGroup()
        let networkService = NetworkService()
        for imageUrl in mainUser.photoAlbum {
            dispatchGroup.enter()
            networkService.fetchImage(string: imageUrl) { [weak self] result in
                switch result {
                case .success(let image):
                    print("Image inside fetchMethod: \(image.size)")
                    self?.photoAlbum?.append(image)
                case .failure(let failure):
                    self?.view?.showErrorAler(error: failure.localizedDescription)
                }
                dispatchGroup.leave()
            }
        }

        dispatchGroup.notify(queue: .main) { [weak self] in
            print("Entering group with imageCOunt: \(self?.photoAlbum?.count)")
            self?.view?.updateAlbum()
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

    func removePostListener() {
        FireStoreService.shared.removeListenerForPosts()
    }

    func removeUserListener() {
        FireStoreService.shared.removeListenerForUser()
    }

    func incrementLikes(post: EachPost) {
        guard let useID = mainUser.documentID, let postID = post.documentID else { return }
        FireStoreService.shared.incrementLikes(user: useID, mainUser: mainUserID, post: postID)
    }

    func decrementLikes(post: EachPost) {
        guard let userID = mainUser.documentID, let postID = post.documentID else { return }
        FireStoreService.shared.decrementLikes(user: userID, mainUser: mainUserID, post: postID)
    }
}
