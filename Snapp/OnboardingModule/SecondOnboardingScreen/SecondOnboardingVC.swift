//
//  SecondOnboardingVC.swift
//  Snapp
//
//  Created by Максим Жуин on 02.04.2024.
//

import Foundation
import UIKit

final class SecondOnboardingVC: UIViewController {

    // MARK: -Properties

    var presenter: SecondOnboardingPresenter!

    private lazy var mainTitle: UILabel = {
        let mainTitle = UILabel()
        mainTitle.translatesAutoresizingMaskIntoConstraints = false
        mainTitle.text = .localized(string: "ЗАРЕГИСТРИРОВАТЬСЯ")
        mainTitle.textColor = ColorCreator.shared.createTextColor()
        mainTitle.font = UIFont(name: "Inter-Medium", size: 18)
        mainTitle.textAlignment = .center
        return mainTitle
    }()

    private lazy var enterPhoneTitle: UILabel = {
        let enterPhoneTitle = UILabel()
        enterPhoneTitle.translatesAutoresizingMaskIntoConstraints = false
        enterPhoneTitle.textColor = .systemGray2
        enterPhoneTitle.textAlignment = .center
        enterPhoneTitle.font = UIFont(name: "Inter-Light", size: 16)
        enterPhoneTitle.text = .localized(string: "Введите номер")
        return enterPhoneTitle
    }()

    private lazy var phoneRequiresTitle: UILabel = {
        let phoneRequiresTitle = UILabel()
        phoneRequiresTitle.translatesAutoresizingMaskIntoConstraints = false
        phoneRequiresTitle.textColor = ColorCreator.shared.createTextColor()
        phoneRequiresTitle.textAlignment = .center
        phoneRequiresTitle.numberOfLines = 0
        phoneRequiresTitle.font = UIFont(name: "Inter-Medium", size: 12)
        phoneRequiresTitle.text = .localized(string: "Ваш номер будет использоваться для входа в аккаунт")
        return phoneRequiresTitle
    }()

    private lazy var phoneTextField: UITextField = {
        let phoneTextField = UITextField()
        phoneTextField.translatesAutoresizingMaskIntoConstraints = false
        phoneTextField.layer.cornerRadius = 10.0
        phoneTextField.layer.borderColor = ColorCreator.shared.createButtonColor().cgColor
        phoneTextField.layer.borderWidth = 1.0
        phoneTextField.keyboardType = .numberPad
        let centeredParagraphStyle = NSMutableParagraphStyle()
        centeredParagraphStyle.alignment = .center

        let attributedString = NSAttributedString(string: "___-___-__", attributes: [NSAttributedString.Key.paragraphStyle: centeredParagraphStyle])
        phoneTextField.attributedPlaceholder = attributedString
        phoneTextField.delegate = self
        return phoneTextField
    }()

    private lazy var nextButton: UIButton = {
        let nextButton = UIButton(type: .system)
        nextButton.backgroundColor = .systemGray4
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        nextButton.setTitle(.localized(string: "Далее"), for: .normal)
        nextButton.setTitleColor(.systemBackground, for: .normal)
        nextButton.titleLabel?.font = UIFont(name: "Inter-Medium", size: 14)
        nextButton.layer.cornerRadius = 10.0
        nextButton.isEnabled = false
        nextButton.addTarget(self, action: #selector(pushThirdController), for: .touchUpInside)
        return nextButton
    }()

    private lazy var politicsTitle: UILabel = {
        let politicsTitle = UILabel()
        politicsTitle.translatesAutoresizingMaskIntoConstraints = false
        politicsTitle.numberOfLines = 0
        politicsTitle.textAlignment = .center
        politicsTitle.font = UIFont(name: "Inter-Medium", size: 12)
        politicsTitle.textColor = .systemGray3
        politicsTitle.text = .localized(string: "Нажимая кнопку “Далее” Вы принимаете пользовательское Соглашение и политику конфиденциальности")
        return politicsTitle
    }()

    // MARK: -Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        tuneNavItem()
        addSubviews()
        layout()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(changeStateOfButton),
                                               name: NSNotification.Name("NumberFullFilled"),
                                               object: nil)
        createGesture()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }

    // MARK: -Funcs

    @objc func dismissController() {
        self.navigationController?.popViewController(animated: true)
    }

    @objc func pushThirdController() {
        let number = phoneTextField.text!
        if presenter.validateText(phone: number) {

            presenter.authentificateUser(phone: number) { [weak self] isAuthorised in
                guard let self = self else { return }
                switch isAuthorised {
                case true:
                    DispatchQueue.main.async { [weak self] in
                        guard let self = self else { return }
                        let thirdController = ThirdOnboardingViewController()
                        let firestoreService = FireStoreService()
                        let thirdPresenter = ThirdOnboardingPresenter(view: thirdController,
                                                                      authService: presenter.authService,
                                                                      firestoreService: firestoreService)
                        thirdController.presenter = thirdPresenter
                        thirdPresenter.number = number
                        navigationController?.pushViewController(thirdController, animated: true)
                    }
                case false:
                    presenter.showError()
                }
            }
        }
    }

    @objc func changeStateOfButton() {
        nextButton.backgroundColor = ColorCreator.shared.createButtonColor()
        nextButton.isEnabled = true
    }

    @objc func tapGestureAction() {
        view.endEditing(true)
        view.becomeFirstResponder()
    }

}

// MARK: -Presenter Output

extension SecondOnboardingVC: SecondOnboardingViewProtocol {

    func showAuthorisationAlert(error: String) {
        let alertController = UIAlertController(title: .localized(string: "Ошибка"),
                                                message: .localized(string: "\(error)"),
                                                preferredStyle: .alert)
        let alertAction = UIAlertAction(title: .localized(string: "Отмена"), style: .cancel)
        alertController.addAction(alertAction)
        navigationController?.present(alertController, animated: true)
    }

    func showAlert() {
        let alertController = UIAlertController(title: .localized(string: "Ошибка"),
                                                message: .localized(string: "Пожалуйста, введите номер в формате +7 ХХХ ХХХ ХХ ХХ"),
                                                preferredStyle: .alert)
        let alertAction = UIAlertAction(title: .localized(string: "Отмена"), style: .cancel)
        alertController.addAction(alertAction)
        navigationController?.present(alertController, animated: true)
    }


}

// MARK: - Layout

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

    private func createGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapGestureAction))
        view.addGestureRecognizer(tapGesture)
    }
}

// MARK: -TextField Delegate

extension SecondOnboardingVC: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return false }

        let newString = (text as NSString).replacingCharacters(in: range, with: string)

        textField.text = StringFormatter.shared.format(with: "+X (XXX) XXX-XXXX", phone: newString)

        if textField.text!.count > 16 {
            NotificationCenter.default.post(name: NSNotification.Name("NumberFullFilled"), object: nil)
        }

        return false
    }
}
