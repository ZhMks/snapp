//
//  ModuleBuilder.swift
//  Snapp
//
//  Created by Максим Жуин on 02.04.2024.
//

import UIKit

protocol ModuleBuilderProtocol {
    static func createFirstOnboardingScreen() -> UIViewController
    static func createSecondOnboardingScreen() -> UIViewController
    static func createThirdOnboardingScreen(with number: String) -> UIViewController
    static func createLoginScreen() -> UIViewController
}

final class ModuleBuilder: ModuleBuilderProtocol {

  static let authService = FireBaseAuthService()

  static  func createFirstOnboardingScreen() -> UIViewController {
        let controller = FirstBoardingVC()
        let presenter = Presenter(view: controller)
        controller.presener = presenter
        return controller
    }

    static func createSecondOnboardingScreen() -> UIViewController {
        let secondController = SecondOnboardingVC()
        let presenter = SecondOnboardingPresenter(view: secondController, authService: authService)
        secondController.presenter = presenter
        return secondController
    }

    static func createThirdOnboardingScreen(with number: String) -> UIViewController {
        let thirdOnboardingController = ThirdOnboardingViewController(number: number)
        let presenter = ThirdOnboardingPresenter(view: thirdOnboardingController, authService: authService)
        thirdOnboardingController.presenter = presenter
        return thirdOnboardingController
    }

    static func createLoginScreen() -> UIViewController {
        let loginScreenVC = LoginScreenViewController()
        let presenter = LoginPresenter(view: loginScreenVC, authService: authService)
        loginScreenVC.loginpresenter = presenter
        return loginScreenVC
    }
}


