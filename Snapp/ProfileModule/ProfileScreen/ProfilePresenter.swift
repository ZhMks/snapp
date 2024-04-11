//
//  ProfilePresenter.swift
//  Snapp
//
//  Created by Максим Жуин on 08.04.2024.
//

import UIKit

protocol ProfileViewProtocol {
    
}

protocol ProfilePresenterProtocol {
    init(view: ProfileViewProtocol, mainUser: UserMainModel, firestoreService: FireStoreServiceProtocol)
}

final class ProfilePresenter: ProfilePresenterProtocol {

    var view: ProfileViewProtocol?
    var mainUser: UserMainModel
    var firestoreService: FireStoreServiceProtocol

    init(view: ProfileViewProtocol, mainUser: UserMainModel, firestoreService: FireStoreServiceProtocol) {
        self.view = view
        self.mainUser = mainUser
        self.firestoreService = firestoreService
    }
}
