//
//  SettingChangeViewController.swift
//  Snapp
//
//  Created by Максим Жуин on 11.07.2024.
//

import UIKit

class SettingChangeViewController: UIViewController {

    var presenter: SettingChangePresenter!

    private lazy var logOutButton: UIButton = {
        let logOutButton = UIButton(type: .system)
        logOutButton.setTitle(.localized(string: "Выйти"), for: .normal)
        logOutButton.titleLabel?.font = UIFont(name:"Inter-Medium", size: 12)
        logOutButton.translatesAutoresizingMaskIntoConstraints = false
        logOutButton.addTarget(self, action: #selector(logOutButtonTapped), for: .touchUpInside)
        return logOutButton
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        addSubviews()
        layout()
    }

    @objc func logOutButtonTapped() {
        let authService = FireBaseAuthService()
        authService.logOut { _ in
            let onboardingVC = FirstBoardingVC()
            let onboardingPresenter = FirstOnBoardingPresenter(view: onboardingVC)
            onboardingVC.presener = onboardingPresenter
            (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(onboardingVC)
        }
    }
}


// MARK: - Presenter output
extension SettingChangeViewController: SettingChangeViewProtocol {
    
}

// MARK: -Layout

extension SettingChangeViewController {
    private func addSubviews() {
        view.addSubview(logOutButton)
    }

    private func layout() {
        let safeArea = view.safeAreaLayoutGuide

        NSLayoutConstraint.activate([
            logOutButton.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            logOutButton.centerYAnchor.constraint(equalTo: safeArea.centerYAnchor)
        ])
    }
}
