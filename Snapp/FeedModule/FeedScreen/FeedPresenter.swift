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
    let nsLock = NSLock()

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
                        self?.nsLock.lock()
                        self?.mainUserStorie = success
                        self?.nsLock.unlock()
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
                                self?.nsLock.lock()
                                self?.userStories?.updateValue(image, forKey: user)
                                self?.nsLock.unlock()
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
            print("Users stories: \(self?.userStories?.keys.count)")
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
        let dispatchGroup = DispatchGroup()
            for sub in mainUser.subscribtions {
                dispatchGroup.enter()
                FireStoreService.shared.getUser(id: sub) { [weak self] result in
                    switch result {
                    case .success(let firebaseUser):
                        FireStoreService.shared.getPosts(sub: firebaseUser.documentID!) { [weak self] result in
                            defer {
                                dispatchGroup.leave()
                            }
                            switch result {
                            case .success(let postArray):
                                self?.nsLock.lock()
                                self?.posts?.updateValue(postArray, forKey: firebaseUser)
                                self?.nsLock.unlock()
                            case .failure(let failure):
                                self?.view?.showError(descr: failure.localizedDescription)
                            }
                        }
                    case .failure(let error):
                        self?.view?.showError(descr: error.localizedDescription)
                    }
                }
            }
       dispatchGroup.notify(queue: .main) { [weak self] in
           self?.view?.updateViewTable()
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
