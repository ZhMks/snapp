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
    let nsLock = NSLock()

    init(view: DetailViewProtocol, user: FirebaseUser, mainUserID: String) {
        self.view = view
        self.user = user
        self.mainUserID = mainUserID
    }

    func updateData() {
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
                self.nsLock.lock()
                self.avatarImage = image
                self.nsLock.unlock()
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
                self.nsLock.lock()
                self.posts = success
                self.nsLock.unlock()
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
                    self.nsLock.lock()
                    self.photoAlbum?.append(image)
                    self.nsLock.unlock()
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
                self.nsLock.lock()
                self.user = user
                self.nsLock.unlock()
                self.fetchImage()
                self.fetchPosts()
                checkSubscribers()
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
                self.nsLock.lock()
                self.posts = success
                self.nsLock.unlock()
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

    func incrementLikes(post: EachPost, user: FirebaseUser) {
        guard let userID = user.documentID, let postID = post.documentID else { return }
        FireStoreService.shared.incrementLikesForPost(user: userID, mainUser: mainUserID, post: postID)
    }

    func decrementLikes(post: EachPost, user: FirebaseUser) {
        guard let userID = user.documentID, let postID = post.documentID else { return }
        FireStoreService.shared.decrementLikesForPost(user: userID, mainUser: mainUserID, post: postID)
    }

    func checkSubscribers() {
        view?.updateSubButton()
    }

    func saveIntoFavourites(post: EachPost, user: FirebaseUser) {
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

    func registerNotifications() {
        NotificationsService.shared.registerNotificationCenter { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(_):
                let body = "\(self.user.name)" + " \(self.user.surname)"
                let title = "Вы подписались на пользователя"
                NotificationsService.shared.postNotification(title: title, body: body)
            case .failure(_):
                return
            }
        }
    }

    func removeSubscribtion() {
        guard let userID = user.documentID else { return }
        FireStoreService.shared.removeSubscribtion(sub: userID, for: mainUserID)
        FireStoreService.shared.removeSubscriber(sub: mainUserID, for: userID)
    }

    func addToBookmarks(post: EachPost, user: FirebaseUser) {
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
}
