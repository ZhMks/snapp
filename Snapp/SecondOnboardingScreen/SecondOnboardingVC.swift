//
//  SecondOnboardingVC.swift
//  Snapp
//
//  Created by Максим Жуин on 02.04.2024.
//

import Foundation
import UIKit

final class SecondOnboardingVC: UIViewController {

    // MARK: -PROPERTIES

    var presenter: SecondOnboardingPresenterProtocol!

    private lazy var mainTitle: UILabel = {
        let mainTitle = UILabel()
        mainTitle.translatesAutoresizingMaskIntoConstraints = false
        mainTitle.text = .localized(string: "Зарегестрироваться")
        mainTitle.textColor = .black
        mainTitle.font = UIFont.systemFont(ofSize: 18)
        mainTitle.textAlignment = .center
        return mainTitle
    }()

    private lazy var enterPhoneTitle: UILabel = {
        let enterPhoneTitle = UILabel()
        enterPhoneTitle.translatesAutoresizingMaskIntoConstraints = false
        enterPhoneTitle.textColor = .systemGray2
        enterPhoneTitle.textAlignment = .center
        enterPhoneTitle.font = UIFont.systemFont(ofSize: 16)
        enterPhoneTitle.text = .localized(string: "Введите номер телефона")
        return enterPhoneTitle
    }()

    private lazy var phoneRequiresTitle: UILabel = {
        let phoneRequiresTitle = UILabel()
        phoneRequiresTitle.translatesAutoresizingMaskIntoConstraints = false
        phoneRequiresTitle.textColor = .black
        phoneRequiresTitle.textAlignment = .center
        phoneRequiresTitle.numberOfLines = 0
        phoneRequiresTitle.font = UIFont.systemFont(ofSize: 12)
        phoneRequiresTitle.text = .localized(string: "Ваш номер будет использоваться для входа в аккаунт")
        return phoneRequiresTitle
    }()

    private lazy var phoneTextField: UITextField = {
        let phoneTextField = UITextField()
        phoneTextField.translatesAutoresizingMaskIntoConstraints = false
        phoneTextField.layer.cornerRadius = 10.0
        phoneTextField.layer.borderColor = UIColor.black.cgColor
        phoneTextField.layer.borderWidth = 1.0
        phoneTextField.keyboardType = .numberPad
        phoneTextField.delegate = self
        return phoneTextField
    }()

    private lazy var nextButton: UIButton = {
        let nextButton = UIButton(type: .system)
        nextButton.backgroundColor = UIColor(named: "ButtonColor")
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        nextButton.setTitle(.localized(string: "Далее"), for: .normal)
        nextButton.setTitleColor(.white, for: .normal)
        nextButton.layer.cornerRadius = 10.0
        nextButton.addTarget(self, action: #selector(pushThirdController), for: .touchUpInside)
        return nextButton
    }()

    private lazy var politicsTitle: UILabel = {
        let politicsTitle = UILabel()
        politicsTitle.translatesAutoresizingMaskIntoConstraints = false
        politicsTitle.numberOfLines = 0
        politicsTitle.textAlignment = .center
        politicsTitle.font = UIFont.systemFont(ofSize: 12)
        politicsTitle.textColor = .systemGray3
        politicsTitle.text = .localized(string: "Нажимая кнопку “Далее” Вы принимаете пользовательское Соглашение и политику конфедициальности")
        return politicsTitle
    }()

    // MARK: -LIFECYCLE

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        tuneNavItem()
        addSubviews()
        layout()
    }

    // MARK: -FUNCS

    @objc func dismissController() {
        self.navigationController?.popViewController(animated: true)
    }

    @objc func pushThirdController() {
        let number = phoneTextField.text ?? "Test Text"
        let thirdController = ModuleBuilder.createThirdOnboardingScreen(with: number)
        self.navigationController?.pushViewController(thirdController, animated: true)
    }

}

// MARK: -OUTPUT PRESENTER

extension SecondOnboardingVC: SecondOnboardingViewProtocol {
}

// MARK: - LAYOUT

extension SecondOnboardingVC {

    private func addSubviews() {
        view.addSubview(mainTitle)
        view.addSubview(enterPhoneTitle)
        view.addSubview(phoneRequiresTitle)
        view.addSubview(phoneTextField)
        view.addSubview(nextButton)
        view.addSubview(politicsTitle)
    }
    private func layout() {
        let safeArea = view.safeAreaLayoutGuide

        NSLayoutConstraint.activate([
            mainTitle.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 60),
            mainTitle.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 76),
            mainTitle.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -76),
            mainTitle.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -607),

            enterPhoneTitle.topAnchor.constraint(equalTo: mainTitle.bottomAnchor, constant: 70),
            enterPhoneTitle.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 126),
            enterPhoneTitle.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -126),
            enterPhoneTitle.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -513),

            phoneRequiresTitle.topAnchor.constraint(equalTo: enterPhoneTitle.bottomAnchor, constant: 5),
            phoneRequiresTitle.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 80),
            phoneRequiresTitle.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -80),
            phoneRequiresTitle.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -478),

            phoneTextField.topAnchor.constraint(equalTo: phoneRequiresTitle.bottomAnchor, constant: 23),
            phoneTextField.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 57),
            phoneTextField.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -58),
            phoneTextField.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -407),

            nextButton.topAnchor.constraint(equalTo: phoneTextField.bottomAnchor, constant: 63),
            nextButton.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 127),
            nextButton.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -128),
            nextButton.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -297),

            politicsTitle.topAnchor.constraint(equalTo: nextButton.bottomAnchor, constant: 30),
            politicsTitle.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 65),
            politicsTitle.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -52),
            politicsTitle.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -222)
        ])
    }
    private func tuneNavItem() {
        let backButton = UIBarButtonItem(image: UIImage(systemName: "arrow.left"), style: .plain, target: self, action: #selector(dismissController))
        backButton.tintColor = .black
        self.navigationItem.leftBarButtonItem = backButton
    }
}

// MARK: -TEXTFIELDDELEGATE

extension SecondOnboardingVC: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let fullstring = textField.text! + string
        print(fullstring)
        textField.text = StringFormatter.shared.phoneNumberFormat(string: fullstring, shouldRemoveLastDigit: range.length == 1)
        return false
    }
}
