//
//  CreatePostPresenter.swift
//  Snapp
//
//  Created by Максим Жуин on 10.05.2024.
//

import UIKit


protocol CreatePostViewProtocol: AnyObject {
   
}

protocol CreatePostPresenterProtocol: AnyObject {
    init(view: CreatePostViewProtocol?, mainUser: FirebaseUser, userID: String, firestoreService: FireStoreServiceProtocol)
}

final class CreatePostPresenter: CreatePostPresenterProtocol {

    let mainUser: FirebaseUser
    weak  var view: CreatePostViewProtocol?
    let userID: String
    let firestoreService: FireStoreServiceProtocol


    init(view: CreatePostViewProtocol?, mainUser: FirebaseUser, userID: String, firestoreService: any FireStoreServiceProtocol) {
        self.mainUser = mainUser
        self.view = view
        self.userID = userID
        self.firestoreService = firestoreService
    }

}
