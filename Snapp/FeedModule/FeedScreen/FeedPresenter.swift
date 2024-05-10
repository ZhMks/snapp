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
}

protocol FeedPresenterProtocol: AnyObject {
    init(view: FeedViewProtocol, user: FirebaseUser, firestoreService: FireStoreServiceProtocol)
    func fetchPosts(user: FirebaseUser)
}


final class FeedPresenter: FeedPresenterProtocol {

    weak var view: FeedViewProtocol?
    var stories: [UIImage]?
    var userStorie: UIImage?
    var user: FirebaseUser
    var posts: [[MainPost]]?
    let firestoreService: FireStoreServiceProtocol?

    init(view: FeedViewProtocol, user: FirebaseUser, firestoreService: FireStoreServiceProtocol) {
        self.view = view
        self.user = user
        self.firestoreService = firestoreService
    }

    func fetchPosts(user: FirebaseUser) {
        for subscriber in user.subscribers {
            firestoreService?.getPosts(sub: subscriber, completion: { [weak self] result in
                guard let self else { return }
                switch result {
                case .success(let mainPost):
                    self.posts?.append(mainPost)
                case .failure(let failure):
                    print()
                }
            })
        }
    }
}
