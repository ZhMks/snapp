//
//  ThirdOnboardingViewController.swift
//  Snapp
//
//  Created by Максим Жуин on 02.04.2024.
//

import UIKit
import FirebaseAuth

class ThirdOnboardingViewController: UIViewController {

    // MARK: -Properties

    var presenter: ThirdOnboardingPresenter!

    private lazy var registrationAccept: UILabel = {
        let registrationAccept = UILabel()
        registrationAccept.translatesAutoresizingMaskIntoConstraints = false
        registrationAccept.text = .localized(string: "Подтверждение регистрации")
        registrationAccept.textAlignment = .center
        registrationAccept.textColor = .systemYellow
        registrationAccept.font = UIFont(name: "Inter-Medium", size: 18)
        return registrationAccept
    }()

    private lazy var informationText: UILabel = {
        let informationText = UILabel()
        informationText.translatesAutoresizingMaskIntoConstraints = false
        informationText.text = .localized(string: "Мы отправили SMS с кодом на номер") + "\n\(presenter.number!)"
        informationText.font = UIFont(name: "Inter-Medium", size: 14)
        informationText.textColor = ColorCreator.shared.createTextColor()
        informationText.textAlignment = .center
        informationText.numberOfLines = 0
        return informationText
    }()

    private lazy var acceptCodeTextField: UITextField = {
        let acceptCodeTextField = UITextField()
        acceptCodeTextField.translatesAutoresizingMaskIntoConstraints = false
        acceptCodeTextField.layer.cornerRadius = 10.0
        acceptCodeTextField.layer.borderColor = ColorCreator.shared.createButtonColor().cgColor
        acceptCodeTextField.layer.borderWidth = 1.0
        acceptCodeTextField.keyboardType = .numberPad
        let centeredParagraphStyle = NSMutableParagraphStyle()
        centeredParagraphStyle.alignment = .center

        let attributedString = NSAttributedString(string: "___-___", attributes: [NSAttributedString.Key.paragraphStyle: centeredParagraphStyle])
        acceptCodeTextField.attributedPlaceholder = attributedString
        return acceptCodeTextField
    }()

    private lazy var registerButton: UIButton = {
        let registerButton = UIButton(type: .system)
        registerButton.backgroundColor = ColorCreator.shared.createButtonColor()
        registerButton.setTitle(.localized(string: "Подтвердить"), for: .normal)
        registerButton.setTitleColor(.systemBackground, for: .normal)
        registerButton.layer.cornerRadius = 10.0
        registerButton.titleLabel?.font = UIFont(name: "Inter-Medium", size: 12)
        registerButton.translatesAutoresizingMaskIntoConstraints = false
        registerButton.addTarget(self, action: #selector(acceptButtonTapped), for: .touchUpInside)
        return registerButton
    }()

    private lazy var checkMarkImage: UIImageView = {
        let checkmark = UIImage(named: "CheckmarkIcon")
        let checkmarkImage = UIImageView(image: checkmark)
        checkmarkImage.translatesAutoresizingMaskIntoConstraints = false
        return checkmarkImage
    }()

    // MARK: -Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        tuneNavItem()
        addSubviews()
        layout()
        createGesture()
    }

    // MARK: -Funcs

    @objc func dismissController() {
        self.navigationController?.popViewController(animated: true)
    }

    @objc func acceptButtonTapped() {
        guard let text = acceptCodeTextField.text else { return }
        presenter.checkCode(code: text)
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



// MARK: -Presenter Output
extension ThirdOnboardingViewController: ThirdOnboardingViewProtocol {

    func showCreateUserScreen() {
        let addProfileVC = AddProfileVc()
        let addProfilePresenter = AddProfilePresenter(view: addProfileVC)
        addProfileVC.presenter = addProfilePresenter
        navigationController?.pushViewController(addProfileVC, animated: true)
    }

    func showUserExistAlert(id: String) {
        let alertController = UIAlertController(title: .localized(string: "Ошибка"), message: .localized(string: "Пользователь с таким номером уже зарегестрирован в системе. ID: \(id)"), preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Отмена", style: .cancel)
        alertController.addAction(alertAction)
        navigationController?.present(alertController, animated: true)
    }

    func showErrorAlert(error: String) {
        let alertController = UIAlertController(title: .localized(string: "Ошибка"), message: .localized(string: "\(error)"), preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Отмена", style: .cancel)
        alertController.addAction(alertAction)
        navigationController?.present(alertController, animated: true)
    }
}

// MARK: -Layout

extension ThirdOnboardingViewController {

    private func addSubviews() {
        view.addSubview(registrationAccept)
        view.addSubview(informationText)
        view.addSubview(acceptCodeTextField)
        view.addSubview(registerButton)
        view.addSubview(checkMarkImage)
    }

    private func layout() {
        let safeArea = view.safeAreaLayoutGuide

        NSLayoutConstraint.activate([
            registrationAccept.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 60),
            registrationAccept.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 66),
            registrationAccept.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -36),
            registrationAccept.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -607),

            informationText.topAnchor.constraint(equalTo: registrationAccept.bottomAnchor, constant: 12),
            informationText.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 67),
            informationText.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -43),
            informationText.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -555),

            acceptCodeTextField.topAnchor.constraint(equalTo: informationText.bottomAnchor, constant: 138),
            acceptCodeTextField.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 58),
            acceptCodeTextField.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -57),
            acceptCodeTextField.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -369),

            registerButton.topAnchor.constraint(equalTo: acceptCodeTextField.bottomAnchor, constant: 86),
            registerButton.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 58),
            registerButton.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -56),
            registerButton.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -236),

            checkMarkImage.topAnchor.constraint(equalTo: registerButton.bottomAnchor, constant: 43),
            checkMarkImage.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 145),
            checkMarkImage.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -144),
            checkMarkImage.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -93)
        ])
    }

    private func tuneNavItem() {
        let backButton = UIBarButtonItem(image: UIImage(systemName: "arrow.left"), style: .plain, target: self, action: #selector(dismissController))
        backButton.tintColor = .black
        self.navigationItem.leftBarButtonItem = backButton
    }
}
