//
//  SignInPresenter.swift
//  Snapp
//
//  Created by Максим Жуин on 12.04.2024.
//

import Foundation



protocol SignInViewProtocol: AnyObject {
    func showAlert()
}

protocol SignInPresenterProtocol: AnyObject {
    init(view: SignInViewProtocol?, firebaseAuth: FireBaseAuthProtocol)
}

final class SignInPresenter: SignInPresenterProtocol {
    
   weak var view: SignInViewProtocol?
    let fireBaseAuthService: FireBaseAuthProtocol

    init(view: SignInViewProtocol?, firebaseAuth: FireBaseAuthProtocol) {
        self.view = view
        self.fireBaseAuthService = firebaseAuth
    }

    func checkCode(code: String, completion: @escaping (Result<FirebaseUser, Error>) -> Void) {
        fireBaseAuthService.verifyCode(code: code) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let user):
                FireStoreService.shared.getUser(id: user.uid) { [weak self] result in
                    guard let self = self else { return }
                    switch result {
                    case .success(let user):
                        completion(.success(user))
                    case .failure(let failure):
                        completion(.failure(failure))
                        self.view?.showAlert()
                    }
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
