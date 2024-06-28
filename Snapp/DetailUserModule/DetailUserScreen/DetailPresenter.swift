//
//  DetailPresenter.swift
//  Snapp
//
//  Created by Максим Жуин on 22.04.2024.
//

import UIKit
import FirebaseAuth

protocol DetailViewProtocol: AnyObject {
    func updateData(data: [EachPost])

    func updateAvatarImage(image: UIImage)

    func showErrorAler(error: String)

    func updateAlbum(image: [UIImage])

    func showFeedMenu(post: EachPost)
}

protocol DetailPresenterProtocol: AnyObject {
    init(view: DetailViewProtocol, user: FirebaseUser, mainUserID: String, firestoreService: FireStoreServiceProtocol)
}

final class DetailPresenter: DetailPresenterProtocol {

    weak var view: DetailViewProtocol?
    let firestoreService: FireStoreServiceProtocol
    var user: FirebaseUser
    var posts: [EachPost] = []
    var image: UIImage?
    let mainUserID: String
    var photoAlbum: [UIImage]?

    init(view: DetailViewProtocol, user: FirebaseUser, mainUserID: String, firestoreService: FireStoreServiceProtocol) {
        self.view = view
        self.user = user
        self.mainUserID = mainUserID
        self.firestoreService = firestoreService
    }

    func fetchImage()  {
        guard let urlLink = user.image else { return }
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
        guard let id = user.documentID else { return }
        firestoreService.getPosts(sub: id) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let success):
                posts = success
                view?.updateData(data: posts)
            case .failure(let failure):
                switch failure.description {
                case  "Ошибка сервера":
                    return
                case "Ошибка декодирования":
                    return
                case "Посты отсутстуют":
                    let data: [EachPost] = []
                    view?.updateData(data: data)
                default: return
                }
            }
        }
    }

    func addSubscriber() {
        guard let id = user.documentID else { return }
        firestoreService.saveSubscriber(mainUser: mainUserID, id: id)
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
                case .success(let data):
                    guard let image = UIImage(data: data) else { return }
                    self.photoAlbum?.append(image)
                case .failure(let failure):
                    self.view?.showErrorAler(error: failure.localizedDescription)
                }
                dispatchGroup.leave()
            }
        }
        dispatchGroup.notify(queue: .main) { [weak self] in
            guard let photoAlbum = self?.photoAlbum else { return }
            self?.view?.updateAlbum(image: photoAlbum)
        }
    }

    func addObserverForuser() {
        guard let id = user.documentID else { return }
        firestoreService.addSnapshotListenerToUser(for: id) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let user):
                self.user = user
            case .failure(_):
                return
            }
        }
    }

    func removeObserverForUser() {
        firestoreService.removeListenerForUser()
    }

    func addObserverForPost() {
        let dispatchQueue = DispatchQueue(label: "inter")
        guard let id = user.documentID else { return }
        firestoreService.addSnapshotListenerToPosts(for: id) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let success):
                self.posts = success
                dispatchQueue.async { [weak self] in
                    self?.fetchPosts()
                    self?.fetchImage()
                }
                fetchPhotoAlbum()
            case .failure(_):
                return
            }
        }
    }

    func removeObserverForPosts() {
        firestoreService.removeListenerForPosts()
    }

    func showFeedMenu(post: EachPost) {
        view?.showFeedMenu(post: post)
    }

    func incrementLikes(post: String) {
        guard let userID = user.documentID else { return }
        firestoreService.incrementLikes(user: userID, mainUser: mainUserID, post: post)
    }

    func decrementLikes(post: String) {
        guard let userID = user.documentID else { return }
        firestoreService.decrementLikes(user: userID, mainUser: mainUserID, post: post)
    }
}
