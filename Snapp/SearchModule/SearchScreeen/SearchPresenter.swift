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
    init(view: SearchViewProtocol?, mainUser: String)
}

final class SearchPresenter: SearchPresenterProtocol {

    weak var view: SearchViewProtocol?
    var usersArray: [FirebaseUser] = []
    let mainUserID: String
    let nsLock = NSLock()

    init(view: SearchViewProtocol?, mainUser: String) {
        self.view = view
        self.mainUserID = mainUser
    }

    deinit {
        print("SearchPresenter is deinited")
    }

    func getAllUsers() {
        FireStoreService.shared.getAllUsers { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let firebaseUserArray):
                var userIDSet = Set(usersArray.map({ $0.documentID }))

                for firebaseUser in firebaseUserArray {
                    guard let documentID = firebaseUser.documentID, documentID != mainUserID else { continue }

                    if !userIDSet.contains(documentID) {
                        nsLock.lock()
                        usersArray.append(firebaseUser)
                        userIDSet.insert(documentID)
                        nsLock.unlock()
                    }
                }
                self.view?.updateTableView()
            case .failure(let failure):
                view?.showErrorAlert(error: failure.localizedDescription)
            }
                self.view?.updateTableView()
        }
    }

    func showNextVC(user: FirebaseUser, userID: String) {
        self.view?.goToNextVC(user: user, userID: userID)
    }
}

