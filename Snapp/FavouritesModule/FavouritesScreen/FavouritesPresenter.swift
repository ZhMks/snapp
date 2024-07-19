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
    init(view: FavouritesViewProtocol?, mainUserID: String)
}

final class FavouritesPresenter: FavouritesPresenterProtocol {

   weak var view: FavouritesViewProtocol?
    var posts: [EachPost]?
    let nsLock = NSLock()
    let mainUserID: String

    init(view: FavouritesViewProtocol?, mainUserID: String) {
        self.view = view
        self.mainUserID = mainUserID
        fetchPosts()
    }

   private func fetchPosts() {
        FireStoreService.shared.fetchFavourites(user: mainUserID) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let success):
                nsLock.lock()
                self.posts = success
                nsLock.unlock()
                view?.updateData()
            case .failure(_):
                return
            }
        }
    }

    func addSnapshotListenerToPost() {
        FireStoreService.shared.addSnapshotListenerToFavourites(for: mainUserID) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let success):
                nsLock.lock()
                self.posts = success
                nsLock.unlock()
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
