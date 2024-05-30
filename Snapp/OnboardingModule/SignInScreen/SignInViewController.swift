//
//  SignInViewController.swift
//  Snapp
//
//  Created by Максим Жуин on 12.04.2024.
//

import UIKit
import FirebaseAuth

class SignInViewController: UIViewController {

    // MARK: -PROPERTIES
    var presenter: SignInPresenter!

    private lazy var topSeparatorView: UIView = {
        let topSeparatorView = UIView()
        topSeparatorView.translatesAutoresizingMaskIntoConstraints = false
        topSeparatorView.backgroundColor = .systemGray6
        return topSeparatorView
    }()

    private lazy var acceptCodeTextField: UITextField = {
        let acceptCodeTextField = UITextField()
        acceptCodeTextField.translatesAutoresizingMaskIntoConstraints = false
        acceptCodeTextField.layer.cornerRadius = 10.0
        acceptCodeTextField.layer.borderColor = ColorCreator.shared.createButtonColor().cgColor
        acceptCodeTextField.layer.borderWidth = 1.0
        acceptCodeTextField.textAlignment = .center
        acceptCodeTextField.keyboardType = .numberPad
        let centeredParagraphStyle = NSMutableParagraphStyle()
        centeredParagraphStyle.alignment = .center

        let attributedString = NSAttributedString(string: "__-__", attributes: [NSAttributedString.Key.paragraphStyle: centeredParagraphStyle])
        acceptCodeTextField.attributedPlaceholder = attributedString
        return acceptCodeTextField
    }()

    private lazy var verifyCodeButton: UIButton = {
        let registerButton = UIButton(type: .system)
        registerButton.backgroundColor = ColorCreator.shared.createButtonColor()
        registerButton.setTitle(.localized(string: "Подтвердить"), for: .normal)
        registerButton.setTitleColor(.systemBackground, for: .normal)
        registerButton.layer.cornerRadius = 10.0
        registerButton.titleLabel?.font = UIFont(name: "Inter-Medium", size: 12)
        registerButton.translatesAutoresizingMaskIntoConstraints = false
        registerButton.addTarget(self, action: #selector(verifyCodeButtonTapped), for: .touchUpInside)
        return registerButton
    }()

// MARK: -LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        addSubviews()
        layout()
        createGesture()
    }

//MARK: -FUNCS
    @objc func verifyCodeButtonTapped() {
        guard let code = acceptCodeTextField.text else { return }
        presenter.checkCode(code: code) { [weak self] result in
            switch result {
            case .success(let user):
                let firestoreService = self?.presenter.firestoreService
                let profileVC = ProfileViewController()
                guard let userID = Auth.auth().currentUser?.uid else { return }
                let presenter = ProfilePresenter(view: profileVC, mainUser: user, userID: userID , firestoreService: firestoreService!)
                profileVC.presenter = presenter
                (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(profileVC, user: user)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }

    @objc func tapGestureAction() {
        view.endEditing(true)
        view.becomeFirstResponder()
    }

    private func createGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapGestureAction))
        view.addGestureRecognizer(tapGesture)
    }
}

// MARK: -PRESENTEROUTPUT
extension SignInViewController: SignInViewProtocol {
    func showAlert() {
        let alertController = UIAlertController(title: .localized(string: "Ошибка"), message: .localized(string: "Пользователь не существует"), preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Отмена", style: .cancel)
        alertController.addAction(alertAction)
        navigationController?.present(alertController, animated: true)
    }
}

//MARK: -LAYOUT

extension SignInViewController {
   private func addSubviews() {
       view.addSubview(topSeparatorView)
        view.addSubview(acceptCodeTextField)
        view.addSubview(verifyCodeButton)
    }

    private  func layout() {
        let safeArea = view.safeAreaLayoutGuide

        NSLayoutConstraint.activate([

            topSeparatorView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 20),
            topSeparatorView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 40),
            topSeparatorView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -40),
            topSeparatorView.heightAnchor.constraint(equalToConstant: 1),

            acceptCodeTextField.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            acceptCodeTextField.centerYAnchor.constraint(equalTo: safeArea.centerYAnchor),
            acceptCodeTextField.heightAnchor.constraint(equalToConstant: 80),
            acceptCodeTextField.widthAnchor.constraint(equalToConstant: 140),

            verifyCodeButton.topAnchor.constraint(equalTo: acceptCodeTextField.bottomAnchor, constant: 56),
            verifyCodeButton.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            verifyCodeButton.heightAnchor.constraint(equalToConstant: 60),
            verifyCodeButton.widthAnchor.constraint(equalToConstant: 120)
        ])
    }
}
