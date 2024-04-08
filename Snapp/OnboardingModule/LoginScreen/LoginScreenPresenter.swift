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
    var authService: FireBaseAuthProtocol? { get set }
    init (view: LoginViewProtocol, authService: FireBaseAuthProtocol)
    func checkPhone(number: String) -> Bool
    func authentificateUser(phone: String, completions: @escaping (Bool) -> Void)
}

final class LoginPresenter: LoginPresenterProtocol {

    weak var view: LoginViewProtocol?
    var authService: FireBaseAuthProtocol?

    init(view: any LoginViewProtocol, authService: FireBaseAuthProtocol) {
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

    func authentificateUser(phone: String, completions: @escaping (Bool) -> Void){

        authService?.signUpUser(phone: phone, completion: { [weak self] success in
            switch success {
            case .success(_):
                completions(true)
            case .failure(_):
                self?.view?.showAlert()
                completions(false)
            }
        })
    }
}
