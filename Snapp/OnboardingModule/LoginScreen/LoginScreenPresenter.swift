//
//  LoginScreenPresenter.swift
//  Snapp
//
//  Created by Максим Жуин on 02.04.2024.
//

import Foundation


protocol LoginViewProtocol: AnyObject {
func showAlert()
}

protocol LoginPresenterProtocol: AnyObject {
    init (view: LoginViewProtocol, authService: FireBaseAuthService)
    func checkPhone(number: String) -> Bool
    func authentificateUser(phone: String) -> Bool
}

final class LoginPresenter: LoginPresenterProtocol {

    weak var view: LoginViewProtocol?
    let authService: FireBaseAuthService

    init(view: any LoginViewProtocol, authService: FireBaseAuthService) {
        self.view = view
        self.authService = authService
   }

    func checkPhone(number: String) -> Bool {
        if Validator.shared.validatePhone(string: number) {
                return true
        }
        view?.showAlert()
        return false
    }

    func authentificateUser(phone: String) -> Bool {
        print(phone)
        authService.signUpUser(phone: phone, completion: { [weak self] success in
            if !success {
                self?.view?.showAlert()
            }
        })
        return true
    }
}
