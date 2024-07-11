//
//  OnBoardingPresenter.swift
//  Snapp
//
//  Created by Максим Жуин on 02.04.2024.
//

import UIKit

protocol FirstOnBoardingViewProtocol: AnyObject {
    func showError(error: String)
}

protocol FirstOnBoardingPresenterProtocol: AnyObject {
    init (view: FirstOnBoardingViewProtocol)
}

final class FirstOnBoardingPresenter: FirstOnBoardingPresenterProtocol {

    weak var view: FirstOnBoardingViewProtocol?

    init(view: any FirstOnBoardingViewProtocol) {
        self.view = view
    }

    func showError(error: String) {
        view?.showError(error: error)
    }
}
