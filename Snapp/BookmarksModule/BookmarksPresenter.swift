//
//  BookmarksPresenter.swift
//  Snapp
//
//  Created by Максим Жуин on 15.06.2024.
//

import UIKit

protocol BookmarksViewProtocol: AnyObject {
func showError()
}

protocol BookmarksPresenterProtocol: AnyObject {
    init(view: BookmarksViewProtocol, user: FirebaseUser, firestoreService: FireStoreServiceProtocol)
}


final class BookmarksPresenter: BookmarksPresenterProtocol {
    weak var view: BookmarksViewProtocol?
    let user: FirebaseUser
    let firestoreService: FireStoreServiceProtocol
    var posts: [EachPost]?

    init(view: BookmarksViewProtocol, user: FirebaseUser, firestoreService: FireStoreServiceProtocol) {
        self.view = view
        self.user = user
        self.firestoreService = firestoreService
    }

    private func fetchBookmarkedPosts() {
        guard let id = user.documentID else { return }
        firestoreService.getPosts(sub: id) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let posts):
                self.posts = posts
            case .failure(let failure):
                view?.showError()
            }
        }
    }
}
