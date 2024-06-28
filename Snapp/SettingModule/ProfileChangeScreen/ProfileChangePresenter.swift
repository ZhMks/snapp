//
//  ProfileChangePresenter.swift
//  Snapp
//
//  Created by Максим Жуин on 08.04.2024.
//

import UIKit

protocol ProfileChangeViewProtocol: AnyObject {
    func presentDataChangeScreen()
    func presentContactsChangeScreen()
    func presentInterestChangeScreen()
    func presentEducationChangeScreen()
    func presentCareerChangeScreen()
    func showError(descr: String)
}

protocol ProfileChangePresenterProtocol: AnyObject {
    init(view: ProfileChangeViewProtocol?, user: FirebaseUser, firestoreService: FireStoreServiceProtocol)
}

final class ProfileChangePresenter: ProfileChangePresenterProtocol {


    weak var view: ProfileChangeViewProtocol?
    var user: FirebaseUser
    var firestoreService: FireStoreServiceProtocol

    init(view: ProfileChangeViewProtocol?, user: FirebaseUser, firestoreService: FireStoreServiceProtocol) {
        self.view = view
        self.user = user
        self.firestoreService = firestoreService
    }

    func goToDetailDataChangeScreen() {
        view?.presentDataChangeScreen()
    }

    func goToContactsChangeScreen() {
        view?.presentContactsChangeScreen()
    }

    func goToInterestsChangeScreen() {
        view?.presentInterestChangeScreen()
    }

    func goToEducationChangeScreen() {
        view?.presentEducationChangeScreen()
    }

    func goToCareerChangeScreen() {
        view?.presentCareerChangeScreen()
    }

    func getUserData() {
        guard let userID = user.documentID else { return }
        firestoreService.getUser(id: userID) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let user):
                self.user = user
            case .failure(let failure):
                view?.showError(descr: failure.localizedDescription)
            }
        }
    }
}
