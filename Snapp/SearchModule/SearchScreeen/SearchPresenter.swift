//
//  SearchPresenter.swift
//  Snapp
//
//  Created by Максим Жуин on 22.04.2024.
//

import Foundation
import FirebaseAuth


protocol SearchViewProtocol: AnyObject {
    func showErrorAlert()
}

protocol SearchPresenterProtocol: AnyObject {
    init(view: SearchViewProtocol?, firestoreService: FireStoreServiceProtocol)
}

final class SearchPresenter: SearchPresenterProtocol {

    weak var view: SearchViewProtocol?
    let firestoreService: FireStoreServiceProtocol
    var usersArray: [FirebaseUser] = []
    var posts: [String: [String : EachPost]] = [:]

    init(view: SearchViewProtocol?, firestoreService: FireStoreServiceProtocol) {
        self.view = view
        self.firestoreService = firestoreService
    }

    func getAllUsers() {
        let currentUser = Auth.auth().currentUser
        firestoreService.getAllUsers { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let firebaseUserArray):
                for user in firebaseUserArray {
                    if user.documentID! != currentUser?.uid {
                        usersArray.append(user)
                    }
                }
            case .failure(let failure):
                view?.showErrorAlert()
            }
        }
    }

    func fetchPostsFor(user: String) {
        firestoreService.getPosts(sub: user) { [weak self] result in
                guard let self else { return }
                switch result {
                case .success(let success):
                    print()
                case .failure(let failure):
                    view?.showErrorAlert()
                }
        }
    }
}

