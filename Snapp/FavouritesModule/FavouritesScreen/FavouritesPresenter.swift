//
//  FavouritesPresenter.swift
//  Snapp
//
//  Created by Максим Жуин on 08.04.2024.
//

import UIKit

protocol FavouritesViewProtocol: AnyObject {}

protocol FavouritesPresenterProtocol: AnyObject {
    init(view: FavouritesViewProtocol?, user: FirebaseUser)
}

final class FavouritesPresenter: FavouritesPresenterProtocol {

   weak var view: FavouritesViewProtocol?
    var user: FirebaseUser

    init(view: FavouritesViewProtocol?, user: FirebaseUser) {
        self.view = view
        self.user = user
    }
}
