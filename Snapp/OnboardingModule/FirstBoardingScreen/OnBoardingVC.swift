//
//  ViewController.swift
//  Snapp
//
//  Created by Максим Жуин on 01.04.2024.
//

import UIKit

class FirstBoardingVC: UIViewController {

    // MARK: -Properties

    var presener: FirstOnBoardingPresenter!
    let authService = FireBaseAuthService()

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
        reloadUser()
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

    private func reloadUser() {
        let activityView = UIView(frame: CGRect(origin: CGPoint(x: 143, y: 430), size: CGSize(width: 100, height: 100)))
        let activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 10, width: 80, height: 80))
        authService.reloadUser { [weak self] user in
            self?.addActivityIndicator(view: activityView, indicator: activityIndicator)
            FireStoreService.shared.getUser(id: user.uid) { [weak self] result in
                switch result {
                case .success(let firebaseUser):
                    self?.remove(view: activityView, indicator: activityIndicator)
                    let profileVc = ProfileViewController()
                    guard let mainUserID = firebaseUser.documentID else { return }
                    let profilePresenter = ProfilePresenter(view: profileVc, mainUser: firebaseUser, mainUserID: mainUserID)
                    profileVc.presenter = profilePresenter
                    (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.setTabBarController(profileVc, user: firebaseUser, mainUserID: mainUserID)
                case .failure(let failure):
                    self?.presener.showError(error: failure.localizedDescription)
                }
            }
        }
    }

    private func addActivityIndicator(view: UIView, indicator: UIActivityIndicatorView) {
        view.backgroundColor = .systemBackground
        view.layer.shadowOffset = CGSize(width: 1.5, height: 1.5)
        view.layer.shadowRadius = 2.0
        view.layer.shadowOpacity = 1.0
        view.layer.shadowColor = UIColor.systemGray5.cgColor
        view.layer.cornerRadius = 10.0

        indicator.style = .large
        indicator.color = .black
        indicator.startAnimating()

        view.addSubview(indicator)
        self.view.addSubview(view)
    }

    private func remove(view: UIView, indicator: UIActivityIndicatorView) {
        indicator.stopAnimating()
        view.removeFromSuperview()
        indicator.removeFromSuperview()
    }
}

// MARK: -Presenter Output
extension FirstBoardingVC: FirstOnBoardingViewProtocol {
    func showError(error: String) {
        DispatchQueue.main.async { [weak self] in
            let uiAlertController = UIAlertController(title: .localized(string: "Ошибка"), message: .localized(string: "\(error)"), preferredStyle: .alert)
            let uiAlertAction = UIAlertAction(title: .localized(string: "Отмена"), style: .cancel)
            uiAlertController.addAction(uiAlertAction)
            self?.present(uiAlertController, animated: true)
        }
    }


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

