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
    func showError(error: String)
}

protocol BookmarksPresenterProtocol: AnyObject {
    init(view: BookmarksViewProtocol, user: FirebaseUser, mainUser: String)
}


final class BookmarksPresenter: BookmarksPresenterProtocol {
    weak var view: BookmarksViewProtocol?
    let user: FirebaseUser
    var posts: [BookmarkedPost]?
    let mainUserID: String

    init(view: BookmarksViewProtocol, user: FirebaseUser, mainUser: String) {
        self.view = view
        self.user = user
        self.mainUserID = mainUser
        fetchBookmarkedPosts()
    }

    func fetchBookmarkedPosts() {
        guard let id = user.documentID else { return }
        FireStoreService.shared.fetchBookmarkedPosts(user: id) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let bookmarkedPosts):
                self.posts = bookmarkedPosts
                fetchUserData()
            case .failure(_):
                view?.showError()
            }
        }
    }

    private func fetchUserData() {
        let dispatchGroup = DispatchGroup()
        guard let posts = posts else { return }
        for post in posts {
            if !post.userHoldingPost.isEmpty {
                let link = post.userHoldingPost
                FireStoreService.shared.getUser(id: link) { [weak self] result in
                    switch result {
                    case .success(let firebaseUser):
                        self?.view?.updateTableView()
                    case .failure(let failure):
                        self?.view?.showError(error: failure.localizedDescription)
                    }
                }
            }
        }
    }
}
