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
    init(view: ProfileViewProtocol, firebaseUser: FirebaseUser, posts: [EachPost], firestoreService: FireStoreServiceProtocol)
}

final class ProfilePresenter: ProfilePresenterProtocol {

    var view: ProfileViewProtocol?
    var firebaseUser: FirebaseUser
    var posts: [EachPost]
    var firestoreService: FireStoreServiceProtocol

    init(view: ProfileViewProtocol, firebaseUser: FirebaseUser, posts: [EachPost], firestoreService: FireStoreServiceProtocol) {
        self.view = view
        self.firebaseUser = firebaseUser
        self.posts = posts
        self.firestoreService = firestoreService
    }
}
