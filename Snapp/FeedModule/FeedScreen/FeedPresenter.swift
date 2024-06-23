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
}

protocol FeedPresenterProtocol: AnyObject {
    init(view: FeedViewProtocol, user: FirebaseUser, firestoreService: FireStoreServiceProtocol)
    func fetchPosts()
}


final class FeedPresenter: FeedPresenterProtocol {

    weak var view: FeedViewProtocol?
    var stories: UIImage?
    var userStories: [UIImage]?
    var mainUser: FirebaseUser
    var posts: [FirebaseUser : [EachPost]]?
    let firestoreService: FireStoreServiceProtocol

    init(view: FeedViewProtocol, user: FirebaseUser, firestoreService: FireStoreServiceProtocol) {
        self.view = view
        self.mainUser = user
        self.firestoreService = firestoreService
        fetchImage()
    }

    func fetchUserStorie() {
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

    func addUserListener() {
        guard let userID = mainUser.documentID else { return }
        firestoreService.addSnapshotListenerToUser(for: userID) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let success):
                self.mainUser = success
                self.fetchPosts()
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
            firestoreService.getUser(id: sub, completion: { [weak self] result in
                guard let self else { return }
                switch result {
                case .success(let success):
                    self.firestoreService.getPosts(sub: sub, completion: { [weak self] result in
                        guard let self else { return }
                        switch result {
                        case .success(let postArray):
                            posts?.updateValue(postArray, forKey: success)
                        case .failure(_):
                            view?.showEmptyScreen()
                        }
                        dispatchGroup.leave()
                    })
                case .failure(_):
                    view?.showEmptyScreen()
                }
            })
        }
        dispatchGroup.notify(queue: .main) { [weak self] in
            guard let self else { return }
            view?.updateViewTable()
        }
    }

    func fetchImage() {
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
