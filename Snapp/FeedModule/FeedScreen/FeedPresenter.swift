//
//  FeedPresenter.swift
//  Snapp
//
//  Created by Максим Жуин on 06.04.2024.
//

import UIKit
import FirebaseStorage

protocol FeedViewProtocol: AnyObject {
    func showEmptyScreen()
    func updateViewTable()
    func updateStorieView()
    func updateAvatarImage(image: UIImage)
    func showMenuForFeed(post: EachPost)
    func showError(descr: String)
}

protocol FeedPresenterProtocol: AnyObject {
    init(view: FeedViewProtocol, user: FirebaseUser, firestoreService: FireStoreServiceProtocol, mainUser: String)
    func fetchPosts()
}


final class FeedPresenter: FeedPresenterProtocol {

    weak var view: FeedViewProtocol?
    var stories: UIImage?
    var userStories: [UIImage]?
    var mainUser: FirebaseUser
    var posts: [FirebaseUser : [EachPost]]?
    let firestoreService: FireStoreServiceProtocol
    let mainUserID: String

    init(view: FeedViewProtocol, user: FirebaseUser, firestoreService: FireStoreServiceProtocol, mainUser: String) {
        self.view = view
        self.mainUser = user
        self.firestoreService = firestoreService
        self.mainUserID = mainUser
        fetchAvatarImage()
    }

    func fetchMainUserStorie() {
        let networkService = NetworkService()
        if !mainUser.stories.isEmpty {
            mainUser.stories.forEach { storie in
                networkService.fetchImage(string: storie) { [weak self] result in
                    switch result {
                    case .success(let success):
                        guard let storieImage = UIImage(data: success) else { return }
                        self?.userStories?.append(storieImage)
                        self?.view?.updateStorieView()
                    case .failure(let failure):
                        print(failure)
                    }
                }
            }
        }
    }

    func fetchSubscribersStorie() {
        let dispatchGroup = DispatchGroup()
        let networkService = NetworkService()
        for sub in mainUser.subscribtions {
            dispatchGroup.enter()
            firestoreService.getUser(id: sub) { [weak self] result in
                guard let self else { return }
                switch result {
                case .success(let user):
                    if !user.stories.isEmpty {
                        for storie in user.stories {
                            networkService.fetchImage(string: storie) { [weak self] result in
                                guard let self else { return }
                                switch result {
                                case .success(let imgData):
                                    guard let image = UIImage(data: imgData) else { return }
                                    self.userStories?.append(image)
                                case .failure(let failure):
                                    view?.showError(descr: failure.localizedDescription)
                                }
                            }
                        }
                        dispatchGroup.leave()
                    }
                case .failure(let failure):
                    view?.showError(descr: failure.localizedDescription)
                }
            }
        }
        dispatchGroup.notify(queue: .main) { [weak self] in
            guard let self else { return }
            view?.updateViewTable()
        }
    }

    func addUserListener() {
        guard let userID = mainUser.documentID else { return }
        firestoreService.addSnapshotListenerToUser(for: userID) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let success):
                self.mainUser = success
                self.fetchPosts()
              //  self.fetchSubscribersStorie()
            case .failure(_):
                self.view?.showEmptyScreen()
            }
        }
    }

    func removeListener() {
        firestoreService.removeListenerForUser()
    }

    func fetchPosts() {
        posts = [:]
        let dispatchGroup = DispatchGroup()
        for sub in mainUser.subscribtions {
            dispatchGroup.enter()
            firestoreService.getUser(id: sub) { [weak self] result in
                guard let self = self else {
                    dispatchGroup.leave()
                    return
                }
                switch result {
                case .success(let firebaseUser):
                    self.firestoreService.getPosts(sub: firebaseUser.documentID!) { [weak self] result in
                        guard let self = self else {
                            dispatchGroup.leave()
                            return
                        }
                        defer {
                            dispatchGroup.leave()
                        }
                        switch result {
                        case .success(let postArray):
                            self.posts?.updateValue(postArray, forKey: firebaseUser)
                        case .failure(let failure):
                            self.view?.showError(descr: failure.localizedDescription)
                        }
                    }
                case .failure(let error):
                    self.view?.showError(descr: error.localizedDescription)
                    dispatchGroup.leave()
                }
            }
        }
        dispatchGroup.notify(queue: .main) { [weak self] in
            guard let self = self else { return }
            self.view?.updateViewTable()
        }
    }

    func fetchAvatarImage() {
        let networkService = NetworkService()
        if let userImage = mainUser.image {
            networkService.fetchImage(string: userImage) { [weak self] result in
                guard let self else { return }
                switch result {
                case .success(let success):
                    guard let image = UIImage(data: success) else { return }
                    view?.updateAvatarImage(image: image)
                case .failure(_):
                    return
                }
            }
        }
    }

    func showMenuForFeed(post: EachPost) {
        view?.showMenuForFeed(post: post)
    }
}
