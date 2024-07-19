//
//  DetailUserInformationViewController.swift
//  Snapp
//
//  Created by Максим Жуин on 18.06.2024.
//

import UIKit

class DetailUserInformationViewController: UIViewController {

    // MARK: - Properties

    var presenter: DetailUserInformationPresenter!

    private lazy var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.text = .localized(string: "Имя")
        nameLabel.font = UIFont(name: "Inter-Bold", size: 14)
        return nameLabel
    }()

    private lazy var nameInformationlabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.text = presenter.mainUser.name
        nameLabel.font = UIFont(name: "Inter-Medium", size: 14)
        return nameLabel
    }()

    private lazy var surnameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.text = .localized(string: "Фамилия")
        nameLabel.font = UIFont(name: "Inter-Bold", size: 14)
        return nameLabel
    }()

    private lazy var surnameInformationlabel: UILabel = {
        let surnameLabel = UILabel()
        surnameLabel.translatesAutoresizingMaskIntoConstraints = false
        surnameLabel.text = presenter.mainUser.surname
        surnameLabel.font = UIFont(name: "Inter-Medium", size: 14)
        return surnameLabel
    }()

    private lazy var careerLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.text = .localized(string: "Работа")
        nameLabel.font = UIFont(name: "Inter-Bold", size: 14)
        return nameLabel
    }()


    private lazy var careerInformationLabel: UILabel = {
        let jobLabel = UILabel()
        jobLabel.translatesAutoresizingMaskIntoConstraints = false
        jobLabel.text = presenter.mainUser.job
        jobLabel.font = UIFont(name: "Inter-Medium", size: 14)
        return jobLabel
    }()

    private lazy var contactsLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.text = .localized(string: "Контакты")
        nameLabel.font = UIFont(name: "Inter-Bold", size: 14)
        return nameLabel
    }()


    private lazy var contactsInformationLabel: UILabel = {
        let contactsLabel = UILabel()
        contactsLabel.translatesAutoresizingMaskIntoConstraints = false
        contactsLabel.text = presenter.mainUser.contacts
        contactsLabel.font = UIFont(name: "Inter-Medium", size: 14)
        return contactsLabel
    }()

    private lazy var educationLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.text = .localized(string: "Образование")
        nameLabel.font = UIFont(name: "Inter-Bold", size: 14)
        return nameLabel
    }()

    private lazy var educationInformationlabel: UILabel = {
        let educationLabel = UILabel()
        educationLabel.translatesAutoresizingMaskIntoConstraints = false
        educationLabel.text = presenter.mainUser.education
        educationLabel.font = UIFont(name: "Inter-Medium", size: 14)
        return educationLabel
    }()

    private lazy var interestsLabel: UILabel = {
        let interestsLabel = UILabel()
        interestsLabel.translatesAutoresizingMaskIntoConstraints = false
        interestsLabel.text = .localized(string: "Интересы")
        interestsLabel.font = UIFont(name: "Inter-Bold", size: 14)
        return interestsLabel
    }()

    private lazy var interestInformationlabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.text = presenter.mainUser.interests
        nameLabel.font = UIFont(name: "Inter-Medium", size: 14)
        return nameLabel
    }()



    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.layer.cornerRadius = 20
        addSubviews()
        layout()
    }

    // MARK: - Funcs

}


// MARK: - Output Presenter

extension DetailUserInformationViewController: DetailUserInformationViewProtocol {

}


// MARK: - Layout

extension DetailUserInformationViewController {

    private func addSubviews() {
        view.addSubview(nameLabel)
        view.addSubview(nameInformationlabel)
        view.addSubview(surnameLabel)
        view.addSubview(surnameInformationlabel)
        view.addSubview(careerLabel)
        view.addSubview(careerInformationLabel)
        view.addSubview(contactsLabel)
        view.addSubview(contactsInformationLabel)
        view.addSubview(educationLabel)
        view.addSubview(educationInformationlabel)
        view.addSubview(interestsLabel)
        view.addSubview(interestInformationlabel)
    }

    private func layout() {
        let safeArea = view.safeAreaLayoutGuide

        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 10),
            nameLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 20),
            nameLabel.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -110),
            nameLabel.heightAnchor.constraint(equalToConstant: 40),

            nameInformationlabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 10),
            nameInformationlabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 20),
            nameInformationlabel.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -80),
            nameInformationlabel.heightAnchor.constraint(equalToConstant: 30),

            surnameLabel.topAnchor.constraint(equalTo: nameInformationlabel.bottomAnchor, constant: 10),
            surnameLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 20),
            surnameLabel.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -110),
            surnameLabel.heightAnchor.constraint(equalToConstant: 40),

            surnameInformationlabel.topAnchor.constraint(equalTo: surnameLabel.bottomAnchor, constant: 10),
            surnameInformationlabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 20),
            surnameInformationlabel.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -80),
            surnameInformationlabel.heightAnchor.constraint(equalToConstant: 30),

            careerLabel.topAnchor.constraint(equalTo: surnameInformationlabel.bottomAnchor, constant: 10),
            careerLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 20),
            careerLabel.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -110),
            careerLabel.heightAnchor.constraint(equalToConstant: 40),

            careerInformationLabel.topAnchor.constraint(equalTo: careerLabel.bottomAnchor, constant: 10),
            careerInformationLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 20),
            careerInformationLabel.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -110),
            careerInformationLabel.heightAnchor.constraint(equalToConstant: 40),

            contactsLabel.topAnchor.constraint(equalTo: careerInformationLabel.bottomAnchor, constant: 10),
            contactsLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 20),
            contactsLabel.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -110),
            contactsLabel.heightAnchor.constraint(equalToConstant: 40),

            contactsInformationLabel.topAnchor.constraint(equalTo: contactsLabel.bottomAnchor, constant: 10),
            contactsInformationLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 20),
            contactsInformationLabel.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -110),
            contactsInformationLabel.heightAnchor.constraint(equalToConstant: 40),

            educationLabel.topAnchor.constraint(equalTo: contactsInformationLabel.bottomAnchor, constant: 10),
            educationLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 20),
            educationLabel.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -110),
            educationLabel.heightAnchor.constraint(equalToConstant: 40),

            educationInformationlabel.topAnchor.constraint(equalTo: educationLabel.bottomAnchor, constant: 10),
            educationInformationlabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 20),
            educationInformationlabel.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -110),
            educationInformationlabel.heightAnchor.constraint(equalToConstant: 40),

            interestsLabel.topAnchor.constraint(equalTo: educationInformationlabel.bottomAnchor, constant: 10),
            interestsLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 20),
            interestsLabel.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -110),
            interestsLabel.heightAnchor.constraint(equalToConstant: 40),

            interestInformationlabel.topAnchor.constraint(equalTo: interestsLabel.bottomAnchor, constant: 10),
            interestInformationlabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 20),
            interestInformationlabel.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -110),
            interestInformationlabel.heightAnchor.constraint(equalToConstant: 40),
        ])
    }
}
