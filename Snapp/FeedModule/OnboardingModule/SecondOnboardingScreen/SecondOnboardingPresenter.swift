//
//  SecondOnboardingPresenter.swift
//  Snapp
//
//  Created by Максим Жуин on 02.04.2024.
//

import Foundation
import FirebaseAuth


protocol SecondOnboardingViewProtocol: AnyObject {
    func showAlert()
}

protocol SecondOnboardingPresenterProtocol: AnyObject {
    var authService: FireBaseAuthProtocol { get set }
    init (view: SecondOnboardingViewProtocol, authService: FireBaseAuthProtocol)
    func validateText(phone: String) -> Bool
    func authentificateUser(phone: String) -> Bool
}

final class SecondOnboardingPresenter: SecondOnboardingPresenterProtocol {

    weak var view: SecondOnboardingViewProtocol?
    var authService: FireBaseAuthProtocol

    init(view: any SecondOnboardingViewProtocol, authService: FireBaseAuthProtocol) {
        self.view = view
        self.authService = authService
    }

    func validateText(phone: String) -> Bool {
        if Validator.shared.validatePhone(string: phone) {
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
