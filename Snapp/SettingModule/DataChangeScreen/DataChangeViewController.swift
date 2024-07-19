//
//  DataChangeViewController.swift
//  Snapp
//
//  Created by Максим Жуин on 21.05.2024.
//

import UIKit

class DataChangeViewController: UIViewController {

    //MARK: -Properties
    var presenter: DataChangePresenter!

    override var prefersStatusBarHidden: Bool {
        return true
    }

    private lazy var nameLabel: UILabel = {
        let firstLabel = UILabel()
        firstLabel.translatesAutoresizingMaskIntoConstraints = false
        firstLabel.font = UIFont(name: "Inter-Medium", size: 12)
        firstLabel.text = .localized(string: "Имя")
        firstLabel.textColor = ColorCreator.shared.createTextColor()
        return firstLabel
    }()

    private lazy var nameLabelTextField: UITextField = {
        let firstTextField = UITextField()
        firstTextField.translatesAutoresizingMaskIntoConstraints = false
        firstTextField.placeholder = .localized(string: "Имя")
        firstTextField.textColor = ColorCreator.shared.createTextColor()
        firstTextField.layer.cornerRadius = 8
        firstTextField.backgroundColor = ColorCreator.shared.createPostBackgroundColor()
        return firstTextField
    }()

    private lazy var surnameLabel: UILabel = {
        let secondLabel = UILabel()
        secondLabel.translatesAutoresizingMaskIntoConstraints = false
        secondLabel.font = UIFont(name: "Inter-Medium", size: 12)
        secondLabel.text = .localized(string: "Фамилия")
        secondLabel.textColor = ColorCreator.shared.createTextColor()
        return secondLabel
    }()

    private lazy var surnameLabelTextField: UITextField = {
        let secondTextField = UITextField()
        secondTextField.translatesAutoresizingMaskIntoConstraints = false
        secondTextField.placeholder = .localized(string: "Фамилия")
        secondTextField.textColor = ColorCreator.shared.createTextColor()
        secondTextField.layer.cornerRadius = 8
        secondTextField.backgroundColor = ColorCreator.shared.createPostBackgroundColor()
        return secondTextField
    }()

    private lazy var genderLabel: UILabel = {
        let thirdLabel = UILabel()
        thirdLabel.translatesAutoresizingMaskIntoConstraints = false
        thirdLabel.font = UIFont(name: "Inter-Medium", size: 12)
        thirdLabel.text = .localized(string: "Пол")
        thirdLabel.textColor = ColorCreator.shared.createTextColor()
        return thirdLabel
    }()

    private lazy var maleButton: UIButton = {
        let maleButton = UIButton(type: .system)
        maleButton.translatesAutoresizingMaskIntoConstraints = false
        maleButton.clipsToBounds = true
        maleButton.layer.cornerRadius = 10
        maleButton.layer.borderWidth = 1.0
        maleButton.layer.borderColor = ColorCreator.shared.createButtonColor().cgColor
        return maleButton
    }()

    private lazy var maleLabel: UILabel = {
        let maleLabel = UILabel()
        maleLabel.translatesAutoresizingMaskIntoConstraints = false
        maleLabel.text = .localized(string: "мужчина")
        maleLabel.font = UIFont(name: "Inter-Light", size: 12)
        return maleLabel
    }()

    private lazy var femaleButton: UIButton = {
        let femaleButton = UIButton(type: .system)
        femaleButton.translatesAutoresizingMaskIntoConstraints = false
        femaleButton.clipsToBounds = true
        femaleButton.layer.cornerRadius = 10
        femaleButton.layer.borderWidth = 1.0
        femaleButton.layer.borderColor = ColorCreator.shared.createButtonColor().cgColor
        return femaleButton
    }()

    private lazy var femaleLabel: UILabel = {
        let femaleLabel = UILabel()
        femaleLabel.translatesAutoresizingMaskIntoConstraints = false
        femaleLabel.text = .localized(string: "женщина")
        femaleLabel.font = UIFont(name: "Inter-Light", size: 12)
        return femaleLabel
    }()

    private lazy var dateOfBirthLabel: UILabel = {
        let fourthLabel = UILabel()
        fourthLabel.translatesAutoresizingMaskIntoConstraints = false
        fourthLabel.font = UIFont(name: "Inter-Medium", size: 12)
        fourthLabel.text = .localized(string: "Дата рождения")
        fourthLabel.textColor = ColorCreator.shared.createTextColor()
        return fourthLabel
    }()

    private lazy var dateOfBirthLabelTextField: UITextField = {
        let fourthTextField = UITextField()
        fourthTextField.translatesAutoresizingMaskIntoConstraints = false
        fourthTextField.placeholder = .localized(string: "Дата рождения")
        fourthTextField.textColor = ColorCreator.shared.createTextColor()
        fourthTextField.layer.cornerRadius = 8
        fourthTextField.backgroundColor = ColorCreator.shared.createPostBackgroundColor()
        return fourthTextField
    }()

    private lazy var idenTifierLabel: UILabel = {
        let fifthLabel = UILabel()
        fifthLabel.translatesAutoresizingMaskIntoConstraints = false
        fifthLabel.font = UIFont(name: "Inter-Medium", size: 12)
        fifthLabel.text = .localized(string: "Идентификатор")
        fifthLabel.textColor = ColorCreator.shared.createTextColor()
        return fifthLabel
    }()

    private lazy var identifierLabelTextField: UITextField = {
        let fifthTextField = UITextField()
        fifthTextField.translatesAutoresizingMaskIntoConstraints = false
        fifthTextField.placeholder = .localized(string: "Идентификатор")
        fifthTextField.textColor = ColorCreator.shared.createTextColor()
        fifthTextField.layer.cornerRadius = 8
        fifthTextField.backgroundColor = ColorCreator.shared.createPostBackgroundColor()
        return fifthTextField
    }()

    private lazy var contactsLabel: UILabel = {
        let fifthLabel = UILabel()
        fifthLabel.translatesAutoresizingMaskIntoConstraints = false
        fifthLabel.font = UIFont(name: "Inter-Medium", size: 12)
        fifthLabel.text = .localized(string: "Контакты")
        fifthLabel.textColor = ColorCreator.shared.createTextColor()
        return fifthLabel
    }()

    private lazy var contactsLabelTextField: UITextField = {
        let fifthTextField = UITextField()
        fifthTextField.translatesAutoresizingMaskIntoConstraints = false
        fifthTextField.placeholder = .localized(string: "Контактная информация")
        fifthTextField.textColor = ColorCreator.shared.createTextColor()
        fifthTextField.layer.cornerRadius = 8
        fifthTextField.backgroundColor = ColorCreator.shared.createPostBackgroundColor()
        return fifthTextField
    }()

    private lazy var interestLabel: UILabel = {
        let fifthLabel = UILabel()
        fifthLabel.translatesAutoresizingMaskIntoConstraints = false
        fifthLabel.font = UIFont(name: "Inter-Medium", size: 12)
        fifthLabel.text = .localized(string: "Интересы")
        fifthLabel.textColor = ColorCreator.shared.createTextColor()
        return fifthLabel
    }()

    private lazy var interestLabelTextField: UITextField = {
        let fifthTextField = UITextField()
        fifthTextField.translatesAutoresizingMaskIntoConstraints = false
        fifthTextField.placeholder = .localized(string: "Интересы")
        fifthTextField.textColor = ColorCreator.shared.createTextColor()
        fifthTextField.layer.cornerRadius = 8
        fifthTextField.backgroundColor = ColorCreator.shared.createPostBackgroundColor()
        return fifthTextField
    }()

    private lazy var jobLabel: UILabel = {
        let fifthLabel = UILabel()
        fifthLabel.translatesAutoresizingMaskIntoConstraints = false
        fifthLabel.font = UIFont(name: "Inter-Medium", size: 12)
        fifthLabel.text = .localized(string: "Работа")
        fifthLabel.textColor = ColorCreator.shared.createTextColor()
        return fifthLabel
    }()

    private lazy var jobLabelTextField: UITextField = {
        let fifthTextField = UITextField()
        fifthTextField.translatesAutoresizingMaskIntoConstraints = false
        fifthTextField.placeholder = .localized(string: "Ключевые обязанности")
        fifthTextField.textColor = ColorCreator.shared.createTextColor()
        fifthTextField.layer.cornerRadius = 8
        fifthTextField.backgroundColor = ColorCreator.shared.createPostBackgroundColor()
        return fifthTextField
    }()

    private lazy var educationLabel: UILabel = {
        let fifthLabel = UILabel()
        fifthLabel.translatesAutoresizingMaskIntoConstraints = false
        fifthLabel.font = UIFont(name: "Inter-Medium", size: 12)
        fifthLabel.text = .localized(string: "Образование")
        fifthLabel.textColor = ColorCreator.shared.createTextColor()
        return fifthLabel
    }()

    private lazy var educationLabelTextField: UITextField = {
        let fifthTextField = UITextField()
        fifthTextField.translatesAutoresizingMaskIntoConstraints = false
        fifthTextField.placeholder = .localized(string: "Образование")
        fifthTextField.textColor = ColorCreator.shared.createTextColor()
        fifthTextField.layer.cornerRadius = 8
        fifthTextField.backgroundColor = ColorCreator.shared.createPostBackgroundColor()
        return fifthTextField
    }()

    //MARK: -Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        tuneNavItem()
        createGesture()
    }

    //MARK: -Funcs

    func tuneNavItem() {
        let settingsButton = UIBarButtonItem(image: UIImage(systemName: "checkmark"),
                                             style: .plain,
                                             target: self,
                                             action: #selector(acceptButtonTapped))
        settingsButton.tintColor = .systemOrange
        self.navigationItem.rightBarButtonItem = settingsButton

        let leftArrowButton = UIButton(type: .system)
        leftArrowButton.setImage(UIImage(systemName: "xmark"), for: .normal)
        leftArrowButton.tintColor = .systemOrange
        leftArrowButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        leftArrowButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)

        let textView = UIView(frame: CGRect(x: 0, y: 0, width: 250, height: 30))
        let title = UILabel(frame: CGRect(x: 40, y: 0, width: 180, height: 30))
        title.text = .localized(string: "Основная информация")
        title.font = UIFont(name: "Inter-Medium", size: 14)
        textView.addSubview(title)
        textView.addSubview(leftArrowButton)
        let leftButton = UIBarButtonItem(customView: textView)
        self.navigationItem.leftBarButtonItem = leftButton
    }

    @objc func acceptButtonTapped()  {
        
        let textFieldsToUpdate: [UITextField: (String)  -> Void] = [
            nameLabelTextField: {  self.presenter.changeName(text: $0) },
            surnameLabelTextField: {  self.presenter.changeSurname(text: $0) },
            dateOfBirthLabelTextField: {  self.presenter.changeDateOfBirth(text: $0) },
            identifierLabelTextField: {  self.presenter.changeIdentifier(text: $0) },
            educationLabelTextField: {  self.presenter.changeEducation(text: $0) },
            jobLabelTextField: {  self.presenter.changeJob(text: $0) },
            interestLabelTextField: { self.presenter.changeInterests(text: $0) },
            contactsLabelTextField: {  self.presenter.changeContacts(text: $0) }
            ]

            let nonEmptyFields = textFieldsToUpdate.filter { !$0.key.text!.isEmpty }

            guard !nonEmptyFields.isEmpty else {
                dismiss(animated: true)
                return
            }

            for (textField, updateMethod) in nonEmptyFields {
                 updateMethod(textField.text!)
            }

            dismiss(animated: true)
    }

    @objc func cancelButtonTapped() {
        dismiss(animated: true)
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
extension DataChangeViewController: DataChangeViewProtocol {

    func layoutForInformationView() {
        addSubviewsForInformation()
        layoutForInformation()
    }
    
    func layoutForContactsView() {
        nameLabel.text = "Контактная информация"
        nameLabel.font = UIFont(name: "Inter-Medium", size: 18)
        addSubviewsForContactsView()
        layoutForContacts()
    }
    
    func layoutForInterestsView() {
        nameLabel.text = "Интересы"
        nameLabel.font = UIFont(name: "Inter-Medium", size: 18)
        addSubviewsForInterests()
        layoutForInterests()
    }
    
    func layoutForEducationView() {
        nameLabel.text = "Образование"
        nameLabel.font = UIFont(name: "Inter-Medium", size: 18)
        addSubViewsForEducation()
        layoutForEducation()
    }
    
    func layoutForCareerView() {
        nameLabel.text = "Карьера"
        nameLabel.font = UIFont(name: "Inter-Medium", size: 18)
        addSubviewsForCareer()
        layoutForCareer()
    }
    

}


//MARK: -Layout
extension DataChangeViewController {

    private func addSubviewsForInformation() {
        view.addSubview(nameLabel)
        view.addSubview(nameLabelTextField)
        view.addSubview(surnameLabel)
        view.addSubview(surnameLabelTextField)
        view.addSubview(genderLabel)
        view.addSubview(maleLabel)
        view.addSubview(maleButton)
        view.addSubview(femaleLabel)
        view.addSubview(femaleButton)
        view.addSubview(dateOfBirthLabel)
        view.addSubview(dateOfBirthLabelTextField)
        view.addSubview(idenTifierLabel)
        view.addSubview(identifierLabelTextField)
    }

    private func layoutForInformation() {
        let safeArea = view.safeAreaLayoutGuide

        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 15),
            nameLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 24),
            nameLabel.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -300),
            nameLabel.heightAnchor.constraint(equalToConstant: 44),

            nameLabelTextField.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 6),
            nameLabelTextField.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 24),
            nameLabelTextField.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -16),
            nameLabelTextField.heightAnchor.constraint(equalToConstant: 40),

            surnameLabel.topAnchor.constraint(equalTo: nameLabelTextField.bottomAnchor, constant: 14),
            surnameLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 24),
            surnameLabel.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -298),
            surnameLabel.heightAnchor.constraint(equalToConstant: 44),

            surnameLabelTextField.topAnchor.constraint(equalTo: surnameLabel.bottomAnchor, constant: 6),
            surnameLabelTextField.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 24),
            surnameLabelTextField.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -16),
            surnameLabelTextField.heightAnchor.constraint(equalToConstant: 40),

            genderLabel.topAnchor.constraint(equalTo: surnameLabelTextField.bottomAnchor, constant: 15),
            genderLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 24),
            genderLabel.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -298),
            genderLabel.heightAnchor.constraint(equalToConstant: 44),

            maleButton.topAnchor.constraint(equalTo: genderLabel.bottomAnchor, constant: 15),
            maleButton.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 24),
            maleButton.heightAnchor.constraint(equalToConstant: 16),
            maleButton.widthAnchor.constraint(equalToConstant: 16),

            maleLabel.centerYAnchor.constraint(equalTo: maleButton.centerYAnchor),
            maleLabel.leadingAnchor.constraint(equalTo: maleButton.trailingAnchor, constant: 14),
            maleLabel.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -180),
            maleLabel.heightAnchor.constraint(equalToConstant: 20),

            femaleButton.topAnchor.constraint(equalTo: maleButton.bottomAnchor, constant: 16),
            femaleButton.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 24),
            femaleButton.heightAnchor.constraint(equalToConstant: 16),
            femaleButton.widthAnchor.constraint(equalToConstant: 16),

            femaleLabel.centerYAnchor.constraint(equalTo: femaleButton.centerYAnchor),
            femaleLabel.leadingAnchor.constraint(equalTo: femaleButton.trailingAnchor, constant: 14),
            femaleLabel.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -180),
            femaleLabel.heightAnchor.constraint(equalToConstant: 20),

            dateOfBirthLabel.topAnchor.constraint(equalTo: femaleButton.bottomAnchor, constant: 15),
            dateOfBirthLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 24),
            dateOfBirthLabel.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -218),
            dateOfBirthLabel.heightAnchor.constraint(equalToConstant: 44),

            dateOfBirthLabelTextField.topAnchor.constraint(equalTo: dateOfBirthLabel.bottomAnchor, constant: 6),
            dateOfBirthLabelTextField.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 24),
            dateOfBirthLabelTextField.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -16),
            dateOfBirthLabelTextField.heightAnchor.constraint(equalToConstant: 40),

            idenTifierLabel.topAnchor.constraint(equalTo: dateOfBirthLabelTextField.bottomAnchor, constant: 15),
            idenTifierLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 24),
            idenTifierLabel.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -218),
            idenTifierLabel.heightAnchor.constraint(equalToConstant: 44),

            identifierLabelTextField.topAnchor.constraint(equalTo: idenTifierLabel.bottomAnchor, constant: 6),
            identifierLabelTextField.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 24),
            identifierLabelTextField.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -16),
            identifierLabelTextField.heightAnchor.constraint(equalToConstant: 40)
        ])
    }

    private func addSubviewsForContactsView() {
        view.addSubview(contactsLabel)
        view.addSubview(contactsLabelTextField)
    }

    private func layoutForContacts() {
        let safeArea = view.safeAreaLayoutGuide

        NSLayoutConstraint.activate([
            contactsLabel.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 20),
            contactsLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 20),
            contactsLabel.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -110),
            contactsLabel.heightAnchor.constraint(equalToConstant: 30),

            contactsLabelTextField.topAnchor.constraint(equalTo: contactsLabel.bottomAnchor, constant: 15),
            contactsLabelTextField.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 20),
            contactsLabelTextField.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -60),
            contactsLabelTextField.heightAnchor.constraint(equalToConstant: 50),
        ])
    }

    private func addSubviewsForInterests() {
        view.addSubview(interestLabel)
        view.addSubview(interestLabelTextField)
    }

    private func layoutForInterests() {
        let safeArea = view.safeAreaLayoutGuide

        NSLayoutConstraint.activate([
            interestLabel.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 20),
            interestLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 20),
            interestLabel.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -110),
            interestLabel.heightAnchor.constraint(equalToConstant: 30),

            interestLabelTextField.topAnchor.constraint(equalTo: interestLabel.bottomAnchor, constant: 15),
            interestLabelTextField.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 20),
            interestLabelTextField.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -60),
            interestLabelTextField.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    private func addSubViewsForEducation() {
        view.addSubview(educationLabel)
        view.addSubview(educationLabelTextField)
    }

    private func layoutForEducation() {
        let safeArea = view.safeAreaLayoutGuide

        NSLayoutConstraint.activate([
            educationLabel.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 20),
            educationLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 20),
            educationLabel.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -110),
            educationLabel.heightAnchor.constraint(equalToConstant: 30),

            educationLabelTextField.topAnchor.constraint(equalTo: educationLabel.bottomAnchor, constant: 15),
            educationLabelTextField.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 20),
            educationLabelTextField.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -60),
            educationLabelTextField.heightAnchor.constraint(equalToConstant: 50)
        ])
    }


    private func addSubviewsForCareer() {
        view.addSubview(jobLabel)
        view.addSubview(jobLabelTextField)
    }

    private func layoutForCareer() {
        let safeArea = view.safeAreaLayoutGuide

        NSLayoutConstraint.activate([
            jobLabel.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 20),
            jobLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 20),
            jobLabel.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -110),
            jobLabel.heightAnchor.constraint(equalToConstant: 30),

            jobLabelTextField.topAnchor.constraint(equalTo: jobLabel.bottomAnchor, constant: 15),
            jobLabelTextField.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 20),
            jobLabelTextField.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -60),
            jobLabelTextField.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
}
