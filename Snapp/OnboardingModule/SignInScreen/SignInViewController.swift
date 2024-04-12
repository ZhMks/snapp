//
//  SignInViewController.swift
//  Snapp
//
//  Created by Максим Жуин on 12.04.2024.
//

import UIKit

class SignInViewController: UIViewController {

    // MARK: -PROPERTIES
    weak var presenter: SignInPresenter!

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

    }
}

// MARK: -PRESENTEROUTPUT
extension SignInViewController: SignInViewProtocol {
    
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
