//
//  FavouritesPresenter.swift
//  Snapp
//
//  Created by Максим Жуин on 08.04.2024.
//

import UIKit

protocol FavouritesViewProtocol {}

protocol FavouritesPresenterProtocol {
    init(view: FavouritesViewProtocol, user: UserMainModel)
}

final class FavouritesPresenter: FavouritesViewProtocol {

    var view: FavouritesViewProtocol?
    var user: UserMainModel

    init(view: FavouritesViewProtocol?, user: UserMainModel) {
        self.view = view
        self.user = user
    }
}
