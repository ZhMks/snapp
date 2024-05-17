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
    var posts: [EachPost]?
    var subscribers: [FirebaseUser]?
    let firestoreService: FireStoreServiceProtocol?

    init(view: FeedViewProtocol, user: FirebaseUser, firestoreService: FireStoreServiceProtocol) {
        self.view = view
        self.mainUser = user
        self.firestoreService = firestoreService
    }

    func fetchPosts() {
        guard let subscribers = subscribers else { return }
        let dispatchGroup = DispatchGroup()
        dispatchGroup.enter()
        for subscriber in subscribers {
            print("SubscriberID: \(subscriber.documentID!)")
            firestoreService?.getPosts(sub: subscriber.documentID!, completion: { [weak self] result in
                guard let self else { return }
                switch result {
                case .success(let mainPost):
                    self.posts = []
                    print("MainPost in presenter: \(mainPost)")
                    self.posts = mainPost
                case .failure(_):
                    print()
                }
                dispatchGroup.leave()
            })
        }
        dispatchGroup.notify(queue: .main) { [weak self] in
            self?.view?.updateViewTable()
        }
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
                    case .failure(let failure):
                        print(failure)
                    }
                }
            }
        }
    }

    func getUsers() {
        let dispatchGroup = DispatchGroup()
        firestoreService?.getAllUsers(completion: { [weak self] result in
            guard let self else { return }
            self.subscribers = []
            switch result {
            case .success(let usersArray):
                for user in usersArray {
                    dispatchGroup.enter()
                    if self.mainUser.subscribers.contains(user.documentID!) {
                        print("Self Subscribers: \(subscribers)")
                        self.subscribers?.append(user)
                    }
                }
                dispatchGroup.leave()
            case .failure(_):
                self.view?.showEmptyScreen()
            }
            dispatchGroup.notify(queue: .main) {
                self.fetchPosts()
            }
        })
    }
}
