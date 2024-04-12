//
//  SignInPresenter.swift
//  Snapp
//
//  Created by Максим Жуин on 12.04.2024.
//

import Foundation



protocol SignInViewProtocol: AnyObject {
}

protocol SignInPresenterProtocol: AnyObject {
    init(view: SignInViewProtocol?)
}

final class SignInPresenter: SignInPresenterProtocol {
    var view: SignInViewProtocol?

    init(view: SignInViewProtocol?) {
        self.view = view
    }
}
