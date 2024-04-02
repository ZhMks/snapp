//
//  SecondOnboardingPresenter.swift
//  Snapp
//
//  Created by Максим Жуин on 02.04.2024.
//

import Foundation


protocol SecondOnboardingViewProtocol: AnyObject {
}

protocol SecondOnboardingPresenterProtocol: AnyObject {
    init (view: SecondOnboardingViewProtocol)
}

final class SecondOnboardingPresenter: SecondOnboardingPresenterProtocol {

    weak var view: SecondOnboardingViewProtocol?

    init(view: any SecondOnboardingViewProtocol) {
        self.view = view
    }

}
