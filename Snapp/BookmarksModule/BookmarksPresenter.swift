//
//  BookmarksPresenter.swift
//  Snapp
//
//  Created by Максим Жуин on 15.06.2024.
//

import UIKit

protocol BookmarksViewProtocol: AnyObject {
func showError()
    func updateTableView()
}

protocol BookmarksPresenterProtocol: AnyObject {
    init(view: BookmarksViewProtocol, user: FirebaseUser, firestoreService: FireStoreServiceProtocol, mainUser: String)
}


final class BookmarksPresenter: BookmarksPresenterProtocol {
    weak var view: BookmarksViewProtocol?
    let user: FirebaseUser
    let firestoreService: FireStoreServiceProtocol
    var posts: [EachPost]?
    let mainUserID: String

    init(view: BookmarksViewProtocol, user: FirebaseUser, firestoreService: FireStoreServiceProtocol, mainUser: String) {
        self.view = view
        self.user = user
        self.firestoreService = firestoreService
        self.mainUserID = mainUser
        fetchBookmarkedPosts()
    }

    private func fetchBookmarkedPosts() {
        guard let id = user.documentID else { return }
        firestoreService.fetchBookmarkedPosts(user: id) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let bookmarkedPosts):
                self.posts = bookmarkedPosts
                view?.updateTableView()
            case .failure(_):
                view?.showError()
            }
        }
    }
}
