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
    init(view: SignInViewProtocol?, firebaseAuth: FireBaseAuthProtocol, userModelService: UserCoreDataModelService)
    func checkCode(code: String, completion: @escaping (Result<UserMainModel, Error>) -> Void)
}

final class SignInPresenter: SignInPresenterProtocol {
    
   weak var view: SignInViewProtocol?
    let fireBaseAuthService: FireBaseAuthProtocol
    let userModelService: UserCoreDataModelService

    init(view: SignInViewProtocol?, firebaseAuth: FireBaseAuthProtocol, userModelService: UserCoreDataModelService) {
        self.view = view
        self.fireBaseAuthService = firebaseAuth
        self.userModelService = userModelService
    }

    func checkCode(code: String, completion: @escaping (Result<UserMainModel, Error>) -> Void) {
        fireBaseAuthService.verifyCode(code: code) { [weak self] result in
            switch result {
            case .success(let user):
                guard let userModel = self?.userModelService.modelArray else { return }
                userModel.forEach { model in
                    print(model.id!)
                    print(user.uid)
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
