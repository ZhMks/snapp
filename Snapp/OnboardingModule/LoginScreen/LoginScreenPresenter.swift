//
//  LoginScreenPresenter.swift
//  Snapp
//
//  Created by Максим Жуин on 02.04.2024.
//

import Foundation


protocol LoginViewProtocol: AnyObject {

}

protocol LoginPresenterProtocol: AnyObject {
    init (view: LoginViewProtocol, authService: FireBaseAuthService)
    func checkPhone(number: String) -> Bool
}

final class LoginPresenter: LoginPresenterProtocol {

    weak var view: LoginViewProtocol?
    let authService: FireBaseAuthService

    init(view: any LoginViewProtocol, authService: FireBaseAuthService) {
        self.view = view
        self.authService = authService
   }

    func checkPhone(number: String) -> Bool {
        
    }
}
