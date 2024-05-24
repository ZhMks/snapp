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
    var posts: [FirebaseUser : [EachPost]]?
    let firestoreService: FireStoreServiceProtocol

    init(view: FeedViewProtocol, user: FirebaseUser, firestoreService: FireStoreServiceProtocol) {
        self.view = view
        self.mainUser = user
        self.firestoreService = firestoreService
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

    func fetchPosts() {
        let dispatchGroup = DispatchGroup()
        posts = [:]
        for sub in mainUser.subscribtions {
            dispatchGroup.enter()
            firestoreService.getUser(id: sub, completion: { [weak self] result in
                guard let self else { return }
                switch result {
                case .success(let success):
                    firestoreService.getPosts(sub: sub, completion: { [weak self] result in
                        guard let self else { return }
                        switch result {
                        case .success(let postArray):
                            posts?.updateValue(postArray, forKey: success)
                        case .failure(let failure):
                            view?.showEmptyScreen()
                        }
                        dispatchGroup.leave()
                    })
                case .failure(let failure):
                    view?.showEmptyScreen()
                }
            })
        }
        dispatchGroup.notify(queue: .main) { [weak self] in
            guard let self else { return }
            view?.updateViewTable()
        }
    }
}
