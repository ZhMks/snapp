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
    init(view: DetailViewProtocol, user: FirebaseUser, userID: String, firestoreService: FireStoreServiceProtocol)
}

final class DetailPresenter: DetailPresenterProtocol {

    weak var view: DetailViewProtocol?
    let firestoreService: FireStoreServiceProtocol
    var user: FirebaseUser
    var posts: [EachPost] = []
    var image: UIImage?
    let userID: String
    var photoAlbum: [UIImage]?

    init(view: DetailViewProtocol, user: FirebaseUser, userID: String, firestoreService: FireStoreServiceProtocol) {
        self.view = view
        self.user = user
        self.userID = userID
        self.firestoreService = firestoreService
        fetchImage()
        fetchPhotoAlbum()
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
        firestoreService.getPosts(sub: userID) { [weak self] result in
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
        guard  let currentUser = Auth.auth().currentUser?.uid else { return }
        firestoreService.saveSubscriber(mainUser: currentUser, id: userID)
    }

    func fetchPhotoAlbum() {
        self.photoAlbum = []
        let networkService = NetworkService()
        let dispatchGroup = DispatchGroup()
        for link in user.photoAlbum {
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
            self?.view?.updateAlbum(image: photoAlbum)
        }
    }

    func addObserverForuser() {
        firestoreService.addSnapshotListenerToUser(for: userID) { [weak self] result in
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
        firestoreService.addSnapshotListenerToPosts(for: userID) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let success):
                self.posts = success
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
}
