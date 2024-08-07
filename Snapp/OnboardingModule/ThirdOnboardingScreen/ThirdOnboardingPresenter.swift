//
//  ThirdOnboardingPresenter.swift
//  Snapp
//
//  Created by Максим Жуин on 02.04.2024.
//

import Foundation


protocol ThirdOnboardingViewProtocol: AnyObject {
    func showCreateUserScreen()
    func showUserExistAlert(id: String)
    func showErrorAlert(error: String)
}

protocol ThirdOnboardingPresenterProtocol: AnyObject {
    init (view: ThirdOnboardingViewProtocol, authService: FireBaseAuthProtocol)
}

final class ThirdOnboardingPresenter: ThirdOnboardingPresenterProtocol {

    weak var view: ThirdOnboardingViewProtocol?
    let authService: FireBaseAuthProtocol
    var number: String?

    init(view: ThirdOnboardingViewProtocol, authService: FireBaseAuthProtocol) {
        self.view = view
        self.authService = authService
    }

    func checkCode(code: String) {
        authService.verifyCode(code: code) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let success):
                FireStoreService.shared.getUser(id: success.uid) { result in
                    switch result {
                    case .success(let user):
                        self.view?.showUserExistAlert(id: user.documentID!)
                    case .failure(_):
                        self.view?.showCreateUserScreen()
                    }
                }
            case .failure(let failure):
                self.view?.showErrorAlert(error: failure.description)
            }
        }
    }
}
