//
//  ViewController.swift
//  Snapp
//
//  Created by Максим Жуин on 01.04.2024.
//

import UIKit

class FirstBoardingVC: UIViewController {

    // MARK: -Properties

    var presener: MainPresenterProtocol!

    private lazy var onboardingImage: UIImageView = {
        let onboardingImage = UIImageView(image: UIImage(named: "OnboardingImage"))
        onboardingImage.translatesAutoresizingMaskIntoConstraints = false
        return onboardingImage
    }()

    private lazy var registerButton: UIButton = {
        let registerButton = UIButton(type: .system)
        registerButton.backgroundColor = ColorCreator.shared.createButtonColor()
        registerButton.translatesAutoresizingMaskIntoConstraints = false
        registerButton.setTitle(.localized(string: "Зарегистрироваться"), for: .normal)
        registerButton.setTitleColor(.systemBackground, for: .normal)
        registerButton.layer.cornerRadius = 10.0
        registerButton.titleLabel?.font = UIFont(name: "Inter-Medium", size: 16)
        registerButton.addTarget(self, action: #selector(showSecondOnboardingVC), for: .touchUpInside)
        return registerButton
    }()

    private lazy var authorizeButton: UIButton = {
        let authorizeButton = UIButton(type: .system)
        authorizeButton.backgroundColor = .clear
        authorizeButton.translatesAutoresizingMaskIntoConstraints = false
        authorizeButton.setTitle(.localized(string: "Уже есть аккаунт"), for: .normal)
        authorizeButton.setTitleColor(ColorCreator.shared.createTextColor(), for: .normal)
        authorizeButton.addTarget(self, action: #selector(showLoginScreen), for: .touchUpInside)
        authorizeButton.titleLabel?.font = UIFont(name: "Inter-Medium", size: 14)
        return authorizeButton
    }()

    // MARK: -Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        addSubviews()
        layout()
    }

    // MARK: -Funcs

    @objc func showSecondOnboardingVC() {
        let authService = FireBaseAuthService()
        let secondController = SecondOnboardingVC()
        let presenter = SecondOnboardingPresenter(view: secondController, authService: authService)
        secondController.presenter = presenter
        navigationController?.pushViewController(secondController, animated: true)
     }

    @objc func showLoginScreen() {
        let authService = FireBaseAuthService()
        let loginScreenVC = LoginScreenViewController()
        let presenter = LoginPresenter(view: loginScreenVC, authService: authService)
        loginScreenVC.loginpresenter = presenter
        navigationController?.pushViewController(loginScreenVC, animated: true)
    }
}

// MARK: -Presenter Output
extension FirstBoardingVC: MainViewProtocol {

}

// MARK: -Layout
extension FirstBoardingVC {
    private func addSubviews() {
        view.addSubview(onboardingImage)
        view.addSubview(registerButton)
        view.addSubview(authorizeButton)
    }

    private func layout() {
        let safeArea = view.safeAreaLayoutGuide

        NSLayoutConstraint.activate([
            onboardingImage.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 29),
            onboardingImage.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -17),
            onboardingImage.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 92),
            onboardingImage.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -327),

            registerButton.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 53),
            registerButton.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -76),
            registerButton.topAnchor.constraint(equalTo: onboardingImage.bottomAnchor, constant: 66),
            registerButton.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -214),

            authorizeButton.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 128),
            authorizeButton.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -124),
            authorizeButton.topAnchor.constraint(equalTo: registerButton.bottomAnchor, constant: 30),
            authorizeButton.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -164)

        ])
    }
}

