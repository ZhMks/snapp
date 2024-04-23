//
//  FavouritesPresenter.swift
//  Snapp
//
//  Created by Максим Жуин on 08.04.2024.
//

import UIKit

protocol FavouritesViewProtocol: AnyObject {}

protocol FavouritesPresenterProtocol: AnyObject {
    init(view: FavouritesViewProtocol?, user: UserMainModel, userModelService: UserCoreDataModelService)
}

final class FavouritesPresenter: FavouritesPresenterProtocol {

   weak var view: FavouritesViewProtocol?
    var user: UserMainModel
    let userModelService: UserCoreDataModelService

    init(view: FavouritesViewProtocol?, user: UserMainModel, userModelService: UserCoreDataModelService) {
        self.view = view
        self.user = user
        self.userModelService = userModelService
    }
}
