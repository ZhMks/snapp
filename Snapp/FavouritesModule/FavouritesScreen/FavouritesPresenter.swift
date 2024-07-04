//
//  FavouritesPresenter.swift
//  Snapp
//
//  Created by Максим Жуин on 08.04.2024.
//

import UIKit

protocol FavouritesViewProtocol: AnyObject {
    func updateData()
}

protocol FavouritesPresenterProtocol: AnyObject {
    init(view: FavouritesViewProtocol?, user: FirebaseUser)
}

final class FavouritesPresenter: FavouritesPresenterProtocol {

   weak var view: FavouritesViewProtocol?
    var user: FirebaseUser
    var posts: [EachPost]?

    init(view: FavouritesViewProtocol?, user: FirebaseUser) {
        self.view = view
        self.user = user
        fetchPosts()
    }

    func fetchPosts() {
        guard let userID = user.documentID else { return }
        FireStoreService.shared.fetchFavourites(user: userID) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let success):
                self.posts = success
                view?.updateData()
            case .failure(_):
                return
            }
        }
    }

    func addSnapshotListenerToPost() {
        guard let userID = user.documentID else { return }
        FireStoreService.shared.addSnapshotListenerToFavourites(for: userID) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let success):
                self.posts = success
                view?.updateData()
            case .failure(_):
                return
            }
        }
    }

    func removeListener() {
        FireStoreService.shared.removeListenerForFavourites()
    }
}
