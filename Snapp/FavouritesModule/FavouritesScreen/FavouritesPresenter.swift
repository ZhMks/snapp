//
//  FavouritesPresenter.swift
//  Snapp
//
//  Created by Максим Жуин on 08.04.2024.
//

import UIKit

protocol FavouritesViewProtocol {}

protocol FavouritesPresenterProtocol {
    init(view: FavouritesViewProtocol, posts: [EachPost])
}

final class FavouritesPresenter: FavouritesViewProtocol {

    var view: FavouritesViewProtocol?
    var posts: [EachPost]

    init(view: FavouritesViewProtocol?, posts: [EachPost]) {
        self.view = view
        self.posts = posts
    }
}