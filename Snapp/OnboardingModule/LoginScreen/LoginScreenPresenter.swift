//
//  LoginScreenPresenter.swift
//  Snapp
//
//  Created by Максим Жуин on 02.04.2024.
//

import Foundation


protocol LoginViewProtocol: AnyObject {
    func showError(error: String)
func showAlert()
}

protocol LoginPresenterProtocol: AnyObject {
    init (view: LoginViewProtocol, authService: FireBaseAuthProtocol)
}

final class LoginPresenter: LoginPresenterProtocol {

    weak var view: LoginViewProtocol?
    let authService: FireBaseAuthProtocol

    init(view: LoginViewProtocol, authService: FireBaseAuthProtocol) {
        self.view = view
        self.authService = authService
   }

    func checkPhone(number: String) -> Bool {
        if Validator.shared.validatePhone(string: number) {
                return true
        }
        return false
    }

    func authentificateUser(phone: String, completions: @escaping (Bool) -> Void){

        authService.signUpUser(phone: phone, completion: { [weak self] success in
            guard let self = self else { return }
            switch success {
            case .success(_):
                completions(true)
            case .failure(let error):
                self.view?.showError(error: error.localizedDescription)
                completions(false)
            }
        })
    }

    func showAlert() {
        view?.showAlert()
    }
}
