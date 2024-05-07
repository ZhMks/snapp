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

    private lazy var acceptCodeTextField: UITextField = {
        let acceptCodeTextField = UITextField()
        acceptCodeTextField.translatesAutoresizingMaskIntoConstraints = false
        acceptCodeTextField.layer.cornerRadius = 10.0
        acceptCodeTextField.layer.borderColor = ColorCreator.shared.createButtonColor().cgColor
        acceptCodeTextField.layer.borderWidth = 1.0
        acceptCodeTextField.keyboardType = .numberPad
        let centeredParagraphStyle = NSMutableParagraphStyle()
        centeredParagraphStyle.alignment = .center

        let attributedString = NSAttributedString(string: "__-__-__-__-__", attributes: [NSAttributedString.Key.paragraphStyle: centeredParagraphStyle])
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
        view.backgroundColor = ColorCreator.shared.createBackgroundColorWithAlpah(alpha: 0.5)
        addSubviews()
        layout()
    }

//MARK: -FUNCS
    @objc func verifyCodeButtonTapped() {
        guard let code = acceptCodeTextField.text else { return }
        presenter.checkCode(code: code) { [weak self] result in
            switch result {
            case .success(let user):
                let fireUser = FirebaseUser(name: "King", surname: "PunchMan", identifier: "KingsPuch", job: "Hero", subscribers: ["Sub1", "Sub2"], subscribtions: ["Sub3", "Sub4"], stories: ["Stories1", "Stories2"], image: "https://firebasestorage.googleapis.com:443/v0/b/snappproject-9ca98.appspot.com/o/users%2FuuptdvnyBrcXwovEv3U69uxMD7m1%2Favatar?alt=media&token=32020d11-35ff-4be8-b96f-009bccb28d4a")
                let firestoreService = self?.presenter.firestoreService
                let profileVC = ProfileViewController()
                guard let userID = Auth.auth().currentUser?.uid else { return }
                let presenter = ProfilePresenter(view: profileVC, mainUser: fireUser, userID: userID , firestoreService: firestoreService!)
                profileVC.presenter = presenter
                (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(profileVC, user: user)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
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
        view.addSubview(acceptCodeTextField)
        view.addSubview(verifyCodeButton)
    }

    private  func layout() {
        let safeArea = view.safeAreaLayoutGuide

        NSLayoutConstraint.activate([
            acceptCodeTextField.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 260),
            acceptCodeTextField.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 66),
            acceptCodeTextField.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -36),
            acceptCodeTextField.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -369),

            verifyCodeButton.topAnchor.constraint(equalTo: acceptCodeTextField.bottomAnchor, constant: 86),
            verifyCodeButton.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 58),
            verifyCodeButton.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -56),
            verifyCodeButton.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -236)
        ])
    }
}
