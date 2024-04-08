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
    init(view: ProfileViewProtocol, firebaseUser: FirebaseUser)
}

final class ProfilePresenter: ProfileViewProtocol {

    var view: ProfileViewProtocol?
    var firebaseUser: FirebaseUser

    init(view: ProfileViewProtocol, firebaseUser: FirebaseUser) {
        self.view = view
        self.firebaseUser = firebaseUser
    }
}
