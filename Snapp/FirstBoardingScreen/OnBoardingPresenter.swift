//
//  OnBoardingPresenter.swift
//  Snapp
//
//  Created by Максим Жуин on 02.04.2024.
//

import UIKit

protocol MainViewProtocol: AnyObject {
    func showSecondOnboardingVC(with number: String)
}

protocol MainPresenterProtocol: AnyObject {
    init (view: MainViewProtocol)
}

final class Presenter: MainPresenterProtocol {
    
    weak var view: MainViewProtocol?

    init(view: any MainViewProtocol) {
        self.view = view
    }
    

}
