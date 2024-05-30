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
    init(view: FavouritesViewProtocol?, user: FirebaseUser, firestoreService: FireStoreServiceProtocol)
}

final class FavouritesPresenter: FavouritesPresenterProtocol {

   weak var view: FavouritesViewProtocol?
    var user: FirebaseUser
    var posts: [EachPost]?
    var firestoreService: FireStoreServiceProtocol

    init(view: FavouritesViewProtocol?, user: FirebaseUser, firestoreService: FireStoreServiceProtocol) {
        self.view = view
        self.user = user
        self.firestoreService = firestoreService
        fetchPosts()
    }

    func fetchPosts() {
        guard let userID = user.documentID else { return }
        firestoreService.fetchFavourites(user: userID) { [weak self] result in
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
        firestoreService.addSnapshotListenerToFavourites(for: userID) { [weak self] result in
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
        firestoreService.removeListenerForFavourites()
    }
}
