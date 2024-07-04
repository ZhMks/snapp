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
    init(view: FeedViewProtocol, user: FirebaseUser, mainUser: String)
}


final class FeedPresenter: FeedPresenterProtocol {

    weak var view: FeedViewProtocol?
    var stories: UIImage?
    var userStories: [UIImage]?
    var mainUser: FirebaseUser
    var posts: [FirebaseUser : [EachPost]]?
    let mainUserID: String

    init(view: FeedViewProtocol, user: FirebaseUser, mainUser: String) {
        self.view = view
        self.mainUser = user
        self.mainUserID = mainUser
    }

    func fetchMainUserStorie() {
        let networkService = NetworkService()
        if !mainUser.stories.isEmpty {
            mainUser.stories.forEach { storie in
                networkService.fetchImage(string: storie) { [weak self] result in
                    switch result {
                    case .success(let success):
                        self?.userStories?.append(success)
                        self?.view?.updateStorieView()
                    case .failure(let failure):
                        print(failure)
                    }
                }
            }
        }
    }

    func fetchSubscribersStorie() {

    }

    func addUserListener() {
        guard let userID = mainUser.documentID else { return }
        FireStoreService.shared.addSnapshotListenerToUser(for: userID) { [weak self] result in
            guard let self = self else { return }
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

//   func fetchPosts() {
//        posts = [:]
//        let dispatchGroup = DispatchGroup()
//        for sub in mainUser.subscribtions {
//            firestoreService.getUser(id: sub) { [weak self] result in
//                guard let self = self else {
//                    dispatchGroup.leave()
//                    return
//                }
//                switch result {
//                case .success(let firebaseUser):
//                    dispatchGroup.enter()
//                    print("Sub inside getUSER: \(firebaseUser.name)")
//                    self.firestoreService.getPosts(sub: firebaseUser.documentID!) { [weak self] result in
//                        guard let self = self else {
//                            dispatchGroup.leave()
//                            return
//                        }
//                        defer {
//                            dispatchGroup.leave()
//                        }
//                        switch result {
//                        case .success(let postArray):
//                            print("Posts for SUB: \(sub): \(postArray)")
//                            self.posts?.updateValue(postArray, forKey: firebaseUser)
//                        case .failure(let failure):
//                            self.view?.showError(descr: failure.localizedDescription)
//                        }
//                    }
//                case .failure(let error):
//                    self.view?.showError(descr: error.localizedDescription)
//                    dispatchGroup.leave()
//                }
//            }
//        }
//        dispatchGroup.notify(queue: .main) { [weak self] in
//            guard let self = self else { return }
//            self.view?.updateViewTable()
//        }
//    }

    func fetchAvatarImage() {
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
