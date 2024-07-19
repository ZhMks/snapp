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
    init(view: ProfileChangeViewProtocol?, user: FirebaseUser, mainUserID: String)
}

final class ProfileChangePresenter: ProfileChangePresenterProtocol {


    weak var view: ProfileChangeViewProtocol?
    var user: FirebaseUser
    var mainUserID: String

    init(view: ProfileChangeViewProtocol?, user: FirebaseUser, mainUserID: String) {
        self.view = view
        self.user = user
        self.mainUserID = mainUserID
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
        FireStoreService.shared.getUser(id: mainUserID) { [weak self] result in
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
