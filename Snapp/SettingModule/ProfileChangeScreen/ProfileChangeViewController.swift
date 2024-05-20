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

    private lazy var profileLabel: UILabel = {
        let profileLabel = UILabel()
        profileLabel.translatesAutoresizingMaskIntoConstraints = false
        profileLabel.text = .localized(string: "\(presenter.user.name)" + "\(presenter.user.surname)")
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
        return mainInformationButton
    }()

    private lazy var contactsButton: UIButton = {
        let contactsButton = UIButton(type: .system)
        contactsButton.translatesAutoresizingMaskIntoConstraints = false
        contactsButton.setTitle(.localized(string: "Контакты"), for: .normal)
        contactsButton.setTitleColor(ColorCreator.shared.createTextColor(), for: .normal)
        return contactsButton
    }()

    private lazy var interestsButton: UIButton = {
        let interestsButton = UIButton(type: .system)
        interestsButton.translatesAutoresizingMaskIntoConstraints = false
        interestsButton.setTitle(.localized(string: "Интересы"), for: .normal)
        interestsButton.setTitleColor(ColorCreator.shared.createTextColor(), for: .normal)
        return interestsButton
    }()

    private lazy var educationButton: UIButton = {
        let educationButton = UIButton(type: .system)
        educationButton.translatesAutoresizingMaskIntoConstraints = false
        educationButton.setTitle(.localized(string: "Образование"), for: .normal)
        educationButton.setTitleColor(ColorCreator.shared.createTextColor(), for: .normal)
        return educationButton
    }()

    private lazy var careerButton: UIButton = {
        let careerButton = UIButton(type: .system)
        careerButton.translatesAutoresizingMaskIntoConstraints = false
        careerButton.setTitle(.localized(string: "Карьера"), for: .normal)
        careerButton.setTitleColor(ColorCreator.shared.createTextColor(), for: .normal)
        return careerButton
    }()


    //MARK: -LIFECYCLE

    override func viewDidLoad() {
        super.viewDidLoad()
        addSubviews()
        layout()
    }


    // MARK: -FUNCS

}


// MARK: -PRESENTEROUTPUT
extension ProfileChangeViewController: ProfileChangeViewProtocol {

}


//MARK: -LAYOUT
extension ProfileChangeViewController {

    func addSubviews() {
        view.addSubview(profileLabel)
        view.addSubview(separatorView)
        view.addSubview(mainInformationButton)
        view.addSubview(contactsButton)
        view.addSubview(interestsButton)
        view.addSubview(educationButton)
        view.addSubview(educationButton)
    }

    func layout() {
        let safeArea = view.safeAreaLayoutGuide

        NSLayoutConstraint.activate([
            profileLabel.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 25),
            profileLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 27),
            profileLabel.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -180),
            profileLabel.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -689),

            separatorView.topAnchor.constraint(equalTo: profileLabel.bottomAnchor, constant: 15),
            separatorView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 25),
            separatorView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -25),
            separatorView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -674),

            mainInformationButton.topAnchor.constraint(equalTo: separatorView.bottomAnchor, constant: 15),
            mainInformationButton.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 27),
            mainInformationButton.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -100),
            mainInformationButton.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -639),

            contactsButton.topAnchor.constraint(equalTo: mainInformationButton.bottomAnchor, constant: 18),
            contactsButton.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 27),
            contactsButton.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -100),
            contactsButton.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -600),

            interestsButton.topAnchor.constraint(equalTo: contactsButton.bottomAnchor, constant: 18),
            interestsButton.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 27),
            interestsButton.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -100),
            interestsButton.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -563),

            educationButton.topAnchor.constraint(equalTo: interestsButton.bottomAnchor, constant: 18),
            educationButton.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 27),
            educationButton.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -100),
            educationButton.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -525),

            educationButton.topAnchor.constraint(equalTo: educationButton.bottomAnchor, constant: 18),
            educationButton.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 27),
            educationButton.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -100),
            educationButton.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -487)
        ])
    }
}
