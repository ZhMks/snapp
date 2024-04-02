//
//  ThirdOnboardingViewController.swift
//  Snapp
//
//  Created by Максим Жуин on 02.04.2024.
//

import UIKit

class ThirdOnboardingViewController: UIViewController {

    var presenter: ThirdOnboardingPresenterProtocol!

    var number: String

    private lazy var registrationAccept: UILabel = {
        let registrationAccept = UILabel()
        registrationAccept.translatesAutoresizingMaskIntoConstraints = false
        registrationAccept.text = .localized(string: "Подтверждение регистрации")
        registrationAccept.textAlignment = .center
        registrationAccept.textColor = .systemYellow
        registrationAccept.font = UIFont.systemFont(ofSize: 18)
        return registrationAccept
    }()

    private lazy var informationText: UILabel = {
        let informationText = UILabel()
        informationText.translatesAutoresizingMaskIntoConstraints = false
        informationText.text = .localized(string: "Мы отправили SMS с кодом на номер \(number)")
        informationText.font = UIFont.systemFont(ofSize: 14)
        informationText.textColor = .black
        informationText.textAlignment = .center
        informationText.numberOfLines = 0
        return informationText
    }()

    private lazy var acceptCodeTextField: UITextField = {
        let acceptCodeTextField = UITextField()
        acceptCodeTextField.translatesAutoresizingMaskIntoConstraints = false
        acceptCodeTextField.layer.cornerRadius = 10.0
        acceptCodeTextField.layer.borderColor = UIColor.black.cgColor
        acceptCodeTextField.layer.borderWidth = 1.0
        acceptCodeTextField.keyboardType = .numberPad
        return acceptCodeTextField
    }()

    private lazy var registerButton: UIButton = {
        let registerButton = UIButton(type: .system)
        registerButton.backgroundColor = UIColor(named: "ButtonColor")
        registerButton.setTitle(.localized(string: "Зарегестрироваться"), for: .normal)
        registerButton.setTitleColor(.white, for: .normal)
        registerButton.layer.cornerRadius = 10.0
        registerButton.translatesAutoresizingMaskIntoConstraints = false
        return registerButton
    }()

    private lazy var checkMarkImage: UIImageView = {
        let checkmark = UIImage(named: "CheckmarkIcon")
        let checkmarkImage = UIImageView(image: checkmark)
        checkmarkImage.translatesAutoresizingMaskIntoConstraints = false
        return checkmarkImage
    }()

    init(number: String) {
        self.number = number
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        tuneNavItem()
        print(number)
        addSubviews()
        layout()
    }

    @objc func dismissController() {
        self.navigationController?.popViewController(animated: true)
    }
}

extension ThirdOnboardingViewController: ThirdOnboardingViewProtocol {

}

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