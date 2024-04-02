//
//  ThirdOnboardingPresenter.swift
//  Snapp
//
//  Created by Максим Жуин on 02.04.2024.
//

import Foundation


protocol ThirdOnboardingViewProtocol: AnyObject {

}

protocol ThirdOnboardingPresenterProtocol: AnyObject {
    init (view: ThirdOnboardingViewProtocol)
}

final class ThirdOnboardingPresenter: ThirdOnboardingPresenterProtocol {

    weak var view: ThirdOnboardingViewProtocol?

    init(view: any ThirdOnboardingViewProtocol) {
        self.view = view
    }
}
