//
//  DetailPresenter.swift
//  Snapp
//
//  Created by Максим Жуин on 22.04.2024.
//

import UIKit
import FirebaseAuth

protocol DetailViewProtocol: AnyObject {
    func updateData()

    func updateAvatarImage(image: UIImage)

    func showErrorAler(error: String)

    func updateAlbum()

    func showFeedMenu(post: EachPost)

    func updateSubButton()
}

protocol DetailPresenterProtocol: AnyObject {
    init(view: DetailViewProtocol, user: FirebaseUser, mainUserID: String)
}

final class DetailPresenter: DetailPresenterProtocol {

    weak var view: DetailViewProtocol?
    var user: FirebaseUser
    var posts: [EachPost] = []
    var avatarImage: UIImage?
    let mainUserID: String
    var photoAlbum: [UIImage]?

    init(view: DetailViewProtocol, user: FirebaseUser, mainUserID: String) {
        self.view = view
        self.user = user
        self.mainUserID = mainUserID
        checkSubscribers()
    }

    deinit {
        print("DetailUserPresenter Deinited")
    }

    func updateData() {
        fetchPhotoAlbum()
        fetchImage()
        fetchPosts()
    }

   private func fetchImage()  {
        guard let urlLink = user.image else { return }
        let networkService = NetworkService()
        networkService.fetchImage(string: urlLink) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let image):
                self.avatarImage = image
                view?.updateAvatarImage(image: image)
            case .failure(let failure):
                view?.showErrorAler(error: failure.localizedDescription)
            }
        }
    }

   private func fetchPosts() {
        guard let id = user.documentID else { return }
       FireStoreService.shared.getPosts(sub: id) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let success):
                self.posts = success
                view?.updateData()
            case .failure(let failure):
                switch failure.description {
                case  "Ошибка сервера":
                    return
                case "Ошибка декодирования":
                    return
                case "Посты отсутстуют":
                   return
                default: return
                }
            }
        }
    }

    func addSubscriber() {
        guard let id = user.documentID else { return }
        FireStoreService.shared.saveSubscriber(mainUser: mainUserID, id: id)
    }

    func fetchPhotoAlbum() {
        self.photoAlbum = []
        let networkService = NetworkService()
        let dispatchGroup = DispatchGroup()
        for link in user.photoAlbum {
            dispatchGroup.enter()
            networkService.fetchImage(string: link) { [weak self] result in
                guard let self = self else {
                    dispatchGroup.leave()
                    return
                }
                switch result {
                case .success(let image):
                    self.photoAlbum?.append(image)
                case .failure(let failure):
                    self.view?.showErrorAler(error: failure.localizedDescription)
                }
                dispatchGroup.leave()
            }
        }
        dispatchGroup.notify(queue: .main) { [weak self] in
            guard let self = self else { return }
            self.view?.updateAlbum()
        }
    }

    func addObserverForuser() {
        guard let id = user.documentID else { return }
        FireStoreService.shared.addSnapshotListenerToUser(for: id) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let user):
                self.user = user
                self.fetchImage()
                self.fetchPosts()
            case .failure(_):
                return
            }
        }
    }

    func removeObserverForUser() {
        FireStoreService.shared.removeListenerForUser()
    }

    func addObserverForPost() {
        guard let id = user.documentID else { return }
        FireStoreService.shared.addSnapshotListenerToPosts(for: id) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let success):
                self.posts = success
                self.view?.updateData()
            case .failure(_):
                return
            }
        }
    }

    func removeObserverForPosts() {
        FireStoreService.shared.removeListenerForPosts()
    }

    func showFeedMenu(post: EachPost) {
        view?.showFeedMenu(post: post)
    }

    func incrementLikes(post: String) {
        guard let userID = user.documentID else { return }
        FireStoreService.shared.incrementLikes(user: userID, mainUser: mainUserID, post: post)
    }

    func decrementLikes(post: String) {
        guard let userID = user.documentID else { return }
        FireStoreService.shared.decrementLikes(user: userID, mainUser: mainUserID, post: post)
    }

    func checkSubscribers() {
        for sub in user.subscribers {
            if sub == mainUserID {
                view?.updateSubButton()
            }
        }
    }
}
