//
//  ThirdOnboardingPresenter.swift
//  Snapp
//
//  Created by Максим Жуин on 02.04.2024.
//

import Foundation


protocol ThirdOnboardingViewProtocol: AnyObject {
func showAlert()
}

protocol ThirdOnboardingPresenterProtocol: AnyObject {
    init (view: ThirdOnboardingViewProtocol, authService: FireBaseAuthService)
    func checkCode(code: String, completion: @escaping (Result<FirebaseUser,Error>) -> Void)
}

final class ThirdOnboardingPresenter: ThirdOnboardingPresenterProtocol {

    weak var view: ThirdOnboardingViewProtocol?
    let authService: FireBaseAuthService

    init(view: any ThirdOnboardingViewProtocol, authService: FireBaseAuthService) {
        self.view = view
        self.authService = authService
    }

    func checkCode(code: String, completion: @escaping (Result<FirebaseUser,Error>) -> Void) {
        authService.verifyCode(code: code) { [weak self] result in
            switch result {
            case .success(let success):
                let user = FirebaseUser(user: success)
                completion(.success(user))
            case .failure(let failure):
                completion(.failure(failure))
                self?.view?.showAlert()
            }
        }
    }
}
