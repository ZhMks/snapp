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
        nameLabel.text = presenter.mainUser.name
        return nameLabel
    }()

    private lazy var surnameLabel: UILabel = {
        let surnameLabel = UILabel()
        surnameLabel.translatesAutoresizingMaskIntoConstraints = false
        surnameLabel.text = presenter.mainUser.surname
        return surnameLabel
    }()

    private lazy var careerLabel: UILabel = {
        let jobLabel = UILabel()
        jobLabel.translatesAutoresizingMaskIntoConstraints = false
        jobLabel.text = presenter.mainUser.job
        return jobLabel
    }()

    private lazy var contactsLabel: UILabel = {
        let contactsLabel = UILabel()
        contactsLabel.translatesAutoresizingMaskIntoConstraints = false
        contactsLabel.text = presenter.mainUser.contacts
        return contactsLabel
    }()

    private lazy var educationLabel: UILabel = {
        let educationLabel = UILabel()
        educationLabel.translatesAutoresizingMaskIntoConstraints = false
        educationLabel.text = presenter.mainUser.education
        return educationLabel
    }()

    private lazy var interestsLabel: UILabel = {
        let interestsLabel = UILabel()
        interestsLabel.translatesAutoresizingMaskIntoConstraints = false
        interestsLabel.text = presenter.mainUser.interests
        return interestsLabel
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
        view.addSubview(surnameLabel)
        view.addSubview(careerLabel)
        view.addSubview(contactsLabel)
        view.addSubview(educationLabel)
        view.addSubview(interestsLabel)
    }

    private func layout() {
        let safeArea = view.safeAreaLayoutGuide

        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 10),
            nameLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 20),
            nameLabel.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -110),
            nameLabel.heightAnchor.constraint(equalToConstant: 40),

            surnameLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 10),
            surnameLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 20),
            surnameLabel.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -110),
            surnameLabel.heightAnchor.constraint(equalToConstant: 40),

            careerLabel.topAnchor.constraint(equalTo: surnameLabel.bottomAnchor, constant: 10),
            careerLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 20),
            careerLabel.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -110),
            careerLabel.heightAnchor.constraint(equalToConstant: 40),

            contactsLabel.topAnchor.constraint(equalTo: careerLabel.bottomAnchor, constant: 10),
            contactsLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 20),
            contactsLabel.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -110),
            contactsLabel.heightAnchor.constraint(equalToConstant: 40),

            educationLabel.topAnchor.constraint(equalTo: contactsLabel.bottomAnchor, constant: 10),
            educationLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 20),
            educationLabel.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -110),
            educationLabel.heightAnchor.constraint(equalToConstant: 40),

            interestsLabel.topAnchor.constraint(equalTo: educationLabel.bottomAnchor, constant: 10),
            interestsLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 20),
            interestsLabel.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -110),
            interestsLabel.heightAnchor.constraint(equalToConstant: 40),
        ])
    }
}
