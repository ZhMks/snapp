//
//  LoginScreenViewController.swift
//  Snapp
//
//  Created by Максим Жуин on 02.04.2024.
//

import UIKit

class LoginScreenViewController: UIViewController {

    // MARK: - PROPERTIES

    var loginpresenter: LoginPresenter!

    private lazy var greetingsLabel: UILabel = {
        let greetingsLabel = UILabel()
        greetingsLabel.translatesAutoresizingMaskIntoConstraints = false
        greetingsLabel.text = .localized(string: "С возвращением")
        greetingsLabel.font = UIFont(name: "Inter-Medium", size: 18)
        greetingsLabel.textColor = .systemYellow
        greetingsLabel.textAlignment = .center
        return greetingsLabel
    }()

    private lazy var mainTextLabel: UILabel = {
        let maintext = UILabel()
        maintext.translatesAutoresizingMaskIntoConstraints = false
        maintext.text = .localized(string: "Введите номер телефона для входа в приложение")
        maintext.font = UIFont(name: "Inter-Medium", size: 14)
        maintext.textColor = ColorCreator.shared.createTextColor()
        maintext.textAlignment = .center
        maintext.numberOfLines = 0
        return maintext
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
        nextButton.backgroundColor = UIColor(named: "ButtonColor")
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        nextButton.titleLabel?.font = UIFont(name: "Inter-Black", size: 14)
        nextButton.setTitle(.localized(string: "Войти"), for: .normal)
        nextButton.setTitleColor(.systemBackground, for: .normal)
        nextButton.layer.cornerRadius = 10.0
        nextButton.addTarget(self, action: #selector(pushThirdController), for: .touchUpInside)
        return nextButton
    }()

    // MARK: -LIFECYCLE

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        addSubviews()
        layout()
        tuneNavItem()
    }

    @objc func pushThirdController() {
        let number = phoneTextField.text ?? "Test Text"
        if loginpresenter.checkPhone(number: number) {
            loginpresenter.authentificateUser(phone: number) { [weak self] result in
                switch result {
                case true:
                    DispatchQueue.main.async { [weak self] in
                        guard let self else { return }
                        let firestoreService = FireStoreService()
                        let thirdController = ThirdOnboardingViewController(number: number)
                        let userModelService = UserCoreDataModelService()
                        let thirdPresenter = ThirdOnboardingPresenter(view: thirdController, authService: loginpresenter.authService!, firestoreService: firestoreService, userModelService: userModelService)
                        thirdController.presenter = thirdPresenter
                        self.navigationController?.pushViewController(thirdController, animated: true)
                    }
                case false:
                    print("ERROR in NUMBER")
                }
            }
        }
    }
}

// MARK: -PRESENTEROUTPUT

extension LoginScreenViewController: LoginViewProtocol {
    func showAlert() {
        let alertController = UIAlertController(title: .localized(string: "Ошибка"),
                                                message: .localized(string: "Пожалуйста, введите номер в формате +7 ХХХ ХХХ ХХ ХХ"),
                                                preferredStyle: .alert)
        let alertAction = UIAlertAction(title: .localized(string: "Отмена"), style: .cancel)
        alertController.addAction(alertAction)
        navigationController?.present(alertController, animated: true)
    }
}

//MARK: -LAYOUT

extension LoginScreenViewController {
    private func addSubviews() {
        view.addSubview(greetingsLabel)
        view.addSubview(mainTextLabel)
        view.addSubview(phoneTextField)
        view.addSubview(nextButton)
    }

    private func layout() {
        let safeArea = view.safeAreaLayoutGuide

        NSLayoutConstraint.activate([
            greetingsLabel.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 177),
            greetingsLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 109),
            greetingsLabel.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -110),
            greetingsLabel.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -531),

            mainTextLabel.topAnchor.constraint(equalTo: greetingsLabel.bottomAnchor, constant: 26),
            mainTextLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 98),
            mainTextLabel.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -98),
            mainTextLabel.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -465),

            phoneTextField.topAnchor.constraint(equalTo: mainTextLabel.bottomAnchor, constant: 12),
            phoneTextField.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 57),
            phoneTextField.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -58),
            phoneTextField.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -405),

            nextButton.topAnchor.constraint(equalTo: phoneTextField.bottomAnchor, constant: 148),
            nextButton.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 93),
            nextButton.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -94),
            nextButton.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -210)
        ])
    }

    private func tuneNavItem() {
        let backButton = UIBarButtonItem(image: UIImage(systemName: "arrow.left"), style: .plain, target: self, action: #selector(dismissController))
        backButton.tintColor = .black
        self.navigationItem.leftBarButtonItem = backButton
    }

    @objc func dismissController() {
        self.navigationController?.popViewController(animated: true)
    }
}

extension LoginScreenViewController: UITextFieldDelegate {
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
