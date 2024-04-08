//
//  FavouritesPresenter.swift
//  Snapp
//
//  Created by Максим Жуин on 08.04.2024.
//

import UIKit

protocol FavouritesViewProtocol {}

protocol FavouritesPresenterProtocol {
    init(view: FavouritesViewProtocol, posts: [EachPost], user: FirebaseUser)
}

final class FavouritesPresenter: FavouritesViewProtocol {

    var view: FavouritesViewProtocol?
    var posts: [EachPost]
    var user: FirebaseUser

    init(view: FavouritesViewProtocol?, posts: [EachPost], user: FirebaseUser) {
        self.view = view
        self.posts = posts
        self.user = user
    }
}
