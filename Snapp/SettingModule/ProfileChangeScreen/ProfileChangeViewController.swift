//
//  ProfileChangeViewController.swift
//  Snapp
//
//  Created by Максим Жуин on 08.04.2024.
//

import UIKit

class ProfileChangeViewController: UIViewController {

    //MARK: -PROPERTIES

    var presenter: ProfileChangePresenter!

    private lazy var mainContentView: UIView = {
        let mainContentView = UIView()
        mainContentView.translatesAutoresizingMaskIntoConstraints = false
        mainContentView.backgroundColor = .systemGray6
        return mainContentView
    }()

    private lazy var closeButton: UIButton = {
        let closeButton = UIButton(type: .system)
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        closeButton.setBackgroundImage(UIImage(systemName: "xmark"), for: .normal)
        closeButton.tintColor = .systemOrange
        closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        return closeButton
    }()

    private lazy var profileLabel: UILabel = {
        let profileLabel = UILabel()
        profileLabel.translatesAutoresizingMaskIntoConstraints = false
        profileLabel.text = .localized(string: "\(presenter.user.name)" + " \(presenter.user.surname)")
        profileLabel.textColor = ColorCreator.shared.createTextColor()
        profileLabel.font = UIFont(name: "Inter-Medium", size: 18)
        return profileLabel
    }()

    private lazy var separatorView: UIView = {
        let separatorView = UIView()
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        separatorView.backgroundColor = .systemGray2
        return separatorView
    }()

    private lazy var mainInformationButton: UIButton = {
        let mainInformationButton = UIButton(type: .system)
        mainInformationButton.translatesAutoresizingMaskIntoConstraints = false
        mainInformationButton.setTitle(.localized(string: "Основаня информация"), for: .normal)
        mainInformationButton.setTitleColor(ColorCreator.shared.createTextColor(), for: .normal)
        mainInformationButton.contentHorizontalAlignment = .left
        mainInformationButton.addTarget(self, action: #selector(showDetailDataChangeScreen), for: .touchUpInside)
        return mainInformationButton
    }()

    private lazy var contactsButton: UIButton = {
        let contactsButton = UIButton(type: .system)
        contactsButton.translatesAutoresizingMaskIntoConstraints = false
        contactsButton.setTitle(.localized(string: "Контакты"), for: .normal)
        contactsButton.setTitleColor(ColorCreator.shared.createTextColor(), for: .normal)
        contactsButton.contentHorizontalAlignment = .left
        return contactsButton
    }()

    private lazy var interestsButton: UIButton = {
        let interestsButton = UIButton(type: .system)
        interestsButton.translatesAutoresizingMaskIntoConstraints = false
        interestsButton.setTitle(.localized(string: "Интересы"), for: .normal)
        interestsButton.setTitleColor(ColorCreator.shared.createTextColor(), for: .normal)
        interestsButton.contentHorizontalAlignment = .left
        return interestsButton
    }()

    private lazy var educationButton: UIButton = {
        let educationButton = UIButton(type: .system)
        educationButton.translatesAutoresizingMaskIntoConstraints = false
        educationButton.setTitle(.localized(string: "Образование"), for: .normal)
        educationButton.setTitleColor(ColorCreator.shared.createTextColor(), for: .normal)
        educationButton.contentHorizontalAlignment = .left
        return educationButton
    }()

    private lazy var careerButton: UIButton = {
        let careerButton = UIButton(type: .system)
        careerButton.translatesAutoresizingMaskIntoConstraints = false
        careerButton.setTitle(.localized(string: "Карьера"), for: .normal)
        careerButton.setTitleColor(ColorCreator.shared.createTextColor(), for: .normal)
        careerButton.contentHorizontalAlignment = .left
        return careerButton
    }()

    //MARK: -LIFECYCLE

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        addSubviews()
        layout()
        view.backgroundColor = ColorCreator.shared.createBackgroundColorWithAlpah(alpha: 0.5)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.isHidden = false
    }


    // MARK: -FUNCS

    @objc func closeButtonTapped() {
        dismiss(animated: true)
    }

    @objc func showDetailDataChangeScreen() {
        let datachangeViewController = DataChangeViewController()
        let navigationController = UINavigationController(rootViewController: datachangeViewController)
        let datachangePresenter = DataChangePresenter(view: datachangeViewController, user: presenter.user, firestoreService: presenter.firestoreService, state: .mainInformation)
        datachangeViewController.presenter = datachangePresenter
        navigationController.modalPresentationStyle = .overCurrentContext
        present(navigationController, animated: true)
    }

}


// MARK: -PRESENTEROUTPUT
extension ProfileChangeViewController: ProfileChangeViewProtocol {

}


//MARK: -LAYOUT
extension ProfileChangeViewController {

    func addSubviews() {
        view.addSubview(mainContentView)
        mainContentView.addSubview(closeButton)
        mainContentView.addSubview(profileLabel)
        mainContentView.addSubview(separatorView)
        mainContentView.addSubview(mainInformationButton)
        mainContentView.addSubview(contactsButton)
        mainContentView.addSubview(interestsButton)
        mainContentView.addSubview(educationButton)
        mainContentView.addSubview(careerButton)
    }

    func layout() {
        let safeArea = view.safeAreaLayoutGuide

        NSLayoutConstraint.activate([
            
            mainContentView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            mainContentView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 62),
            mainContentView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            mainContentView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),

            closeButton.topAnchor.constraint(equalTo: mainContentView.topAnchor, constant: 5),
            closeButton.leadingAnchor.constraint(equalTo: mainContentView.leadingAnchor, constant: 30),
            closeButton.heightAnchor.constraint(equalToConstant: 35),
            closeButton.widthAnchor.constraint(equalToConstant: 35),

            profileLabel.topAnchor.constraint(equalTo: closeButton.bottomAnchor, constant: 25),
            profileLabel.leadingAnchor.constraint(equalTo: mainContentView.leadingAnchor, constant: 30),
            profileLabel.trailingAnchor.constraint(equalTo: mainContentView.trailingAnchor, constant: -101),
            profileLabel.heightAnchor.constraint(equalToConstant: 22),

            separatorView.topAnchor.constraint(equalTo: profileLabel.bottomAnchor, constant: 18),
            separatorView.leadingAnchor.constraint(equalTo: mainContentView.leadingAnchor, constant: 30),
            separatorView.trailingAnchor.constraint(equalTo: mainContentView.trailingAnchor, constant: -30),
            separatorView.heightAnchor.constraint(equalToConstant: 1),

            mainInformationButton.topAnchor.constraint(equalTo: separatorView.bottomAnchor, constant: 15),
            mainInformationButton.leadingAnchor.constraint(equalTo: mainContentView.leadingAnchor, constant: 14),
            mainInformationButton.trailingAnchor.constraint(equalTo: mainContentView.trailingAnchor, constant: -110),
            mainInformationButton.heightAnchor.constraint(equalToConstant: 22),

            contactsButton.topAnchor.constraint(equalTo: mainInformationButton.bottomAnchor, constant: 18),
            contactsButton.leadingAnchor.constraint(equalTo: mainContentView.leadingAnchor, constant: 14),
            contactsButton.trailingAnchor.constraint(equalTo: mainContentView.trailingAnchor, constant: -110),
            contactsButton.heightAnchor.constraint(equalToConstant: 22),

            interestsButton.topAnchor.constraint(equalTo: contactsButton.bottomAnchor, constant: 18),
            interestsButton.leadingAnchor.constraint(equalTo: mainContentView.leadingAnchor, constant: 14),
            interestsButton.trailingAnchor.constraint(equalTo: mainContentView.trailingAnchor, constant: -110),
            interestsButton.heightAnchor.constraint(equalToConstant: 22),

            educationButton.topAnchor.constraint(equalTo: interestsButton.bottomAnchor, constant: 18),
            educationButton.leadingAnchor.constraint(equalTo: mainContentView.leadingAnchor, constant: 14),
            educationButton.trailingAnchor.constraint(equalTo: mainContentView.trailingAnchor, constant: -110),
            educationButton.heightAnchor.constraint(equalToConstant: 22),

            careerButton.topAnchor.constraint(equalTo: educationButton.bottomAnchor, constant: 18),
            careerButton.leadingAnchor.constraint(equalTo: mainContentView.leadingAnchor, constant: 14),
            careerButton.trailingAnchor.constraint(equalTo: mainContentView.trailingAnchor, constant: -110),
            careerButton.heightAnchor.constraint(equalToConstant: 22)
        ])
    }
}
