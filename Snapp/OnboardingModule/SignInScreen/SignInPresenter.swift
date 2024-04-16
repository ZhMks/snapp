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
    init(view: SignInViewProtocol?, firebaseAuth: FireBaseAuthProtocol, userModelService: UserCoreDataModelService, firestoreService: FireStoreServiceProtocol)
    func checkCode(code: String, completion: @escaping (Result<UserMainModel, Error>) -> Void)
}

final class SignInPresenter: SignInPresenterProtocol {
    
   weak var view: SignInViewProtocol?
    let fireBaseAuthService: FireBaseAuthProtocol
    let userModelService: UserCoreDataModelService
    let firestoreService: FireStoreServiceProtocol

    init(view: SignInViewProtocol?, firebaseAuth: FireBaseAuthProtocol, userModelService: UserCoreDataModelService, firestoreService: FireStoreServiceProtocol) {
        self.view = view
        self.fireBaseAuthService = firebaseAuth
        self.userModelService = userModelService
        self.firestoreService = firestoreService
    }

    func checkCode(code: String, completion: @escaping (Result<UserMainModel, Error>) -> Void) {
        fireBaseAuthService.verifyCode(code: code) { [weak self] result in
            switch result {
            case .success(let user):
                guard let userModel = self?.userModelService.modelArray else { return }
                userModel.forEach { model in
                    if model.id! == user.uid {
                        completion(.success(model))
                    } else {
                        self?.view?.showAlert()
                    }
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
