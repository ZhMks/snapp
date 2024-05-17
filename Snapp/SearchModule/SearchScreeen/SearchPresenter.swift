//
//  SearchPresenter.swift
//  Snapp
//
//  Created by Максим Жуин on 22.04.2024.
//

import UIKit
import FirebaseAuth


protocol SearchViewProtocol: AnyObject {
    func showErrorAlert(error: String)
    func goToNextVC(user: FirebaseUser, userID: String)
    func updateTableView()
}

protocol SearchPresenterProtocol: AnyObject {
    init(view: SearchViewProtocol?, firestoreService: FireStoreServiceProtocol)
    func showNextVC(user: FirebaseUser, userID: String)
}

final class SearchPresenter: SearchPresenterProtocol {

    weak var view: SearchViewProtocol?
    let firestoreService: FireStoreServiceProtocol
    var usersArray: [FirebaseUser] = []

    init(view: SearchViewProtocol?, firestoreService: FireStoreServiceProtocol) {
        self.view = view
        self.firestoreService = firestoreService
    }

    func getAllUsers() {
        let currentUser = Auth.auth().currentUser
        firestoreService.getAllUsers { [weak self] result in
            guard let self else { return }
            let dispatchGroup = DispatchGroup()
            switch result {
            case .success(let firebaseUserArray):
                dispatchGroup.enter()
                for firebaseUser in firebaseUserArray {
                    if usersArray.isEmpty {
                        if firebaseUser.documentID! != (currentUser?.uid)! {
                            usersArray.append(firebaseUser)
                        }
                    } else if usersArray.contains(where: { $0.documentID == firebaseUser.documentID! }) {
                        return
                    } else {
                        usersArray.append(firebaseUser)
                    }
                }
                dispatchGroup.leave()
            case .failure(let failure):
                view?.showErrorAlert(error: failure.localizedDescription)
            }
            dispatchGroup.notify(queue: .main) {
                self.view?.updateTableView()
            }
        }
    }

    func showNextVC(user: FirebaseUser, userID: String) {
        self.view?.goToNextVC(user: user, userID: userID)
    }
}

