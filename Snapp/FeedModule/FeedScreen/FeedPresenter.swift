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
    func updateMainStorie()
}

protocol FeedPresenterProtocol: AnyObject {
    init(view: FeedViewProtocol, user: FirebaseUser, mainUser: String)
}


final class FeedPresenter: FeedPresenterProtocol {

    weak var view: FeedViewProtocol?
    var mainUserStorie: UIImage?
    var userStories: [FirebaseUser: UIImage]?
    var mainUser: FirebaseUser
    var posts: [FirebaseUser : [EachPost]]?
    let mainUserID: String

    init(view: FeedViewProtocol, user: FirebaseUser, mainUser: String) {
        self.view = view
        self.mainUser = user
        self.mainUserID = mainUser
    }

    func fetchMainUserStorie() {
        let dispatchGroup = DispatchGroup()

        let networkService = NetworkService()
        if !mainUser.stories.isEmpty {
            mainUser.stories.forEach { storie in
                dispatchGroup.enter()
                networkService.fetchImage(string: storie) { [weak self] result in
                    switch result {
                    case .success(let success):
                        self?.mainUserStorie = success
                    case .failure(let failure):
                        print(failure)
                    }
                    dispatchGroup.leave()
                }
            }
            dispatchGroup.notify(queue: .main) { [weak self] in
                self?.view?.updateMainStorie()
            }
        }
    }

    func fetchSubscribersStorie() {
        let networkService = NetworkService()
        let dispatchGroup = DispatchGroup()
        userStories = [:]
        for subscriber in mainUser.subscribtions {
            dispatchGroup.enter()
            print("Entered group for uesr: \(subscriber)")
            FireStoreService.shared.getUser(id: subscriber) { [weak self] result in
                switch result {
                case .success(let user):
                    if let userImageURL = user.image {
                        networkService.fetchImage(string: userImageURL) { [weak self] result in
                            switch result {
                            case .success(let image):
                                print("Fetched images: \(image)")
                                self?.userStories?.updateValue(image, forKey: user)
                            case .failure(let failure):
                                self?.view?.showError(descr: failure.localizedDescription)
                            }
                            print("Leaved group for user: \(subscriber)")
                            dispatchGroup.leave()
                        }
                    }
                case .failure(let failure):
                    self?.view?.showError(descr: failure.localizedDescription)
                }
            }
        }
        dispatchGroup.notify(queue: .main) { [weak self] in
            self?.view?.updateStorieView()
        }
    }

    func addUserListener() {
        guard let userID = mainUser.documentID else { return }
        FireStoreService.shared.addSnapshotListenerToUser(for: userID) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let success):
                self.mainUser = success
                self.fetchPosts()
                self.fetchSubscribersStorie()
                self.fetchMainUserStorie()
            case .failure(_):
                self.view?.showEmptyScreen()
            }
        }
    }

   func removeListener() {
       FireStoreService.shared.removeListenerForUser()
    }

   func fetchPosts() {
        posts = [:]
        let semaphore = DispatchSemaphore(value: 0)
        let queue = DispatchQueue.global(qos: .background)

        queue.async { [weak self] in
            guard let self = self else { return }
            for sub in mainUser.subscribtions {
                FireStoreService.shared.getUser(id: sub) { [weak self] result in
                    guard let self = self else {
                        semaphore.signal()
                        return
                    }
                    switch result {
                    case .success(let firebaseUser):
                        FireStoreService.shared.getPosts(sub: firebaseUser.documentID!) { [weak self] result in
                            guard let self = self else {
                                semaphore.signal()
                                return
                            }
                            switch result {
                            case .success(let postArray):
                                self.posts?.updateValue(postArray, forKey: firebaseUser)
                            case .failure(let failure):
                                self.view?.showError(descr: failure.localizedDescription)
                            }
                            semaphore.signal()
                        }
                    case .failure(let error):
                        self.view?.showError(descr: error.localizedDescription)
                        semaphore.signal()
                    }
                }
                semaphore.wait()
            }

            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.view?.updateViewTable()
            }
        }
    }

    func fetchAvatarImage() {
        self.mainUserStorie = nil
        let networkService = NetworkService()
        if let userImage = mainUser.image {
            networkService.fetchImage(string: userImage) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let image):
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
