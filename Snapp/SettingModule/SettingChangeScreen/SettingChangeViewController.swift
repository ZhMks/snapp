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
        logOutButton.titleLabel?.font = UIFont(name:"Inter-Medium", size: 18)
        logOutButton.layer.cornerRadius = 10.0
        logOutButton.titleLabel?.textColor = ColorCreator.shared.createTextColor()
        logOutButton.backgroundColor = ColorCreator.shared.createButtonColor()
        logOutButton.translatesAutoresizingMaskIntoConstraints = false
        logOutButton.addTarget(self, action: #selector(logOutButtonTapped), for: .touchUpInside)
        return logOutButton
    }()

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tuneNavItem()
    }

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

    private func tuneNavItem() {

        let uiView = UIView(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
        let leftArrowButton = UIButton(type: .system)
        leftArrowButton.frame = CGRect(x: 0, y: 0, width: 25, height: 25)
        leftArrowButton.setBackgroundImage(UIImage(systemName: "arrow.left"), for: .normal)
        leftArrowButton.tintColor = .systemOrange
        leftArrowButton.addTarget(self, action: #selector(dismissViewController), for: .touchUpInside)

        uiView.addSubview(leftArrowButton)
        let leftButton = UIBarButtonItem(customView: uiView)
        self.navigationItem.leftBarButtonItem = leftButton
    }

    @objc func dismissViewController() {
        self.navigationController?.popViewController(animated: true)
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
