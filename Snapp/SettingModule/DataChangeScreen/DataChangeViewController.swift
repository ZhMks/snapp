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

    private lazy var firstLabel: UILabel = {
        let firstLabel = UILabel()
        firstLabel.translatesAutoresizingMaskIntoConstraints = false
        firstLabel.font = UIFont(name: "Inter-Medium", size: 12)
        firstLabel.text = .localized(string: "Имя")
        firstLabel.textColor = ColorCreator.shared.createTextColor()
        return firstLabel
    }()

    private lazy var firstTextField: UITextField = {
        let firstTextField = UITextField()
        firstTextField.translatesAutoresizingMaskIntoConstraints = false
        firstTextField.placeholder = .localized(string: "Имя")
        firstTextField.textColor = ColorCreator.shared.createTextColor()
        firstTextField.layer.cornerRadius = 8
        firstTextField.backgroundColor = ColorCreator.shared.createPostBackgroundColor()
        return firstTextField
    }()

    private lazy var secondLabel: UILabel = {
        let secondLabel = UILabel()
        secondLabel.translatesAutoresizingMaskIntoConstraints = false
        secondLabel.font = UIFont(name: "Inter-Medium", size: 12)
        secondLabel.text = .localized(string: "Фамилия")
        secondLabel.textColor = ColorCreator.shared.createTextColor()
        return secondLabel
    }()

    private lazy var secondTextField: UITextField = {
        let secondTextField = UITextField()
        secondTextField.translatesAutoresizingMaskIntoConstraints = false
        secondTextField.placeholder = .localized(string: "Фамилия")
        secondTextField.textColor = ColorCreator.shared.createTextColor()
        secondTextField.layer.cornerRadius = 8
        secondTextField.backgroundColor = ColorCreator.shared.createPostBackgroundColor()
        return secondTextField
    }()

    private lazy var thirdLabel: UILabel = {
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
        return femaleButton
    }()

    private lazy var femaleLabel: UILabel = {
        let femaleLabel = UILabel()
        femaleLabel.translatesAutoresizingMaskIntoConstraints = false
        femaleLabel.text = .localized(string: "женщина")
        femaleLabel.font = UIFont(name: "Inter-Light", size: 12)
        return femaleLabel
    }()

    private lazy var fourthLabel: UILabel = {
        let fourthLabel = UILabel()
        fourthLabel.translatesAutoresizingMaskIntoConstraints = false
        fourthLabel.font = UIFont(name: "Inter-Medium", size: 12)
        fourthLabel.text = .localized(string: "Дата рождения")
        fourthLabel.textColor = ColorCreator.shared.createTextColor()
        return fourthLabel
    }()

    private lazy var fourthTextField: UITextField = {
        let fourthTextField = UITextField()
        fourthTextField.translatesAutoresizingMaskIntoConstraints = false
        fourthTextField.placeholder = .localized(string: "Дата рождения")
        fourthTextField.textColor = ColorCreator.shared.createTextColor()
        fourthTextField.layer.cornerRadius = 8
        fourthTextField.backgroundColor = ColorCreator.shared.createPostBackgroundColor()
        return fourthTextField
    }()

    private lazy var fifthLabel: UILabel = {
        let fifthLabel = UILabel()
        fifthLabel.translatesAutoresizingMaskIntoConstraints = false
        fifthLabel.font = UIFont(name: "Inter-Medium", size: 12)
        fifthLabel.text = .localized(string: "Идентификатор")
        fifthLabel.textColor = ColorCreator.shared.createTextColor()
        return fifthLabel
    }()

    private lazy var fifthTextField: UITextField = {
        let fifthTextField = UITextField()
        fifthTextField.translatesAutoresizingMaskIntoConstraints = false
        fifthTextField.placeholder = .localized(string: "Идентификатор")
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
        let title = UILabel(frame: CGRect(x: 40, y: 0, width: 150, height: 30))
        title.text = .localized(string: "Основная информация")
        title.font = UIFont(name: "Inter-Medium", size: 14)
        textView.addSubview(title)
        textView.addSubview(leftArrowButton)
        let leftButton = UIBarButtonItem(customView: textView)
        self.navigationItem.leftBarButtonItem = leftButton
    }

    @objc func acceptButtonTapped()  {
        
        let textFieldsToUpdate: [UITextField: (String)  -> Void] = [
            firstTextField: {  self.presenter.changeName(text: $0) },
            secondTextField: {  self.presenter.changeSurnamet(text: $0) },
            fourthTextField: {  self.presenter.changeSurnamet(text: $0) },
            fifthTextField: {  self.presenter.changeCity(text: $0) }
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

    func updateButtonView() {
        femaleButton.layer.cornerRadius = 10
        femaleButton.layer.borderWidth = 1.0
        femaleButton.layer.borderColor = ColorCreator.shared.createButtonColor().cgColor

        maleButton.layer.cornerRadius = 10
        maleButton.layer.borderWidth = 1.0
        maleButton.layer.borderColor = ColorCreator.shared.createButtonColor().cgColor
    }
}


// MARK: -Presenter Output
extension DataChangeViewController: DataChangeViewProtocol {

    func layoutForInformationView() {
        addSubviewsForInformation()
        layoutForInformation()
        updateButtonView()
    }
    
    func layoutForContactsView() {
        firstLabel.text = "Контактная информация"
        firstLabel.font = UIFont(name: "Inter-Medium", size: 18)
        addSubviewsForContactsView()
        layoutForContacts()
    }
    
    func layoutForInterestsView() {
        firstLabel.text = "Интересы"
        firstLabel.font = UIFont(name: "Inter-Medium", size: 18)
        addSubviewsForInterests()
        layoutForInterests()
    }
    
    func layoutForEducationView() {
        firstLabel.text = "Образование"
        firstLabel.font = UIFont(name: "Inter-Medium", size: 18)
        addSubViewsForEducation()
        layoutForEducation()
    }
    
    func layoutForCareerView() {
        firstLabel.text = "Карьера"
        firstLabel.font = UIFont(name: "Inter-Medium", size: 18)
        addSubviewsForCareer()
        layoutForCareer()
    }
    

}


//MARK: -Layout
extension DataChangeViewController {

    private func addSubviewsForInformation() {
        view.addSubview(firstLabel)
        view.addSubview(firstTextField)
        view.addSubview(secondLabel)
        view.addSubview(secondTextField)
        view.addSubview(thirdLabel)
        view.addSubview(maleLabel)
        view.addSubview(maleButton)
        view.addSubview(femaleLabel)
        view.addSubview(femaleButton)
        view.addSubview(fourthLabel)
        view.addSubview(fourthTextField)
        view.addSubview(fifthLabel)
        view.addSubview(fifthTextField)
    }

    private func layoutForInformation() {
        let safeArea = view.safeAreaLayoutGuide

        NSLayoutConstraint.activate([
            firstLabel.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 15),
            firstLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 24),
            firstLabel.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -300),
            firstLabel.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -640),

            firstTextField.topAnchor.constraint(equalTo: firstLabel.bottomAnchor, constant: 6),
            firstTextField.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 24),
            firstTextField.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -16),
            firstTextField.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -580),

            secondLabel.topAnchor.constraint(equalTo: firstTextField.bottomAnchor, constant: 14),
            secondLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 24),
            secondLabel.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -298),
            secondLabel.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -556),

            secondTextField.topAnchor.constraint(equalTo: secondLabel.bottomAnchor, constant: 6),
            secondTextField.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 24),
            secondTextField.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -16),
            secondTextField.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -509),

            thirdLabel.topAnchor.constraint(equalTo: secondTextField.bottomAnchor, constant: 15),
            thirdLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 24),
            thirdLabel.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -298),
            thirdLabel.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -517),

            maleButton.topAnchor.constraint(equalTo: thirdLabel.bottomAnchor, constant: 15),
            maleButton.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 24),
            maleButton.heightAnchor.constraint(equalToConstant: 16),
            maleButton.widthAnchor.constraint(equalToConstant: 16),

            maleLabel.centerYAnchor.constraint(equalTo: maleButton.centerYAnchor),
            maleLabel.leadingAnchor.constraint(equalTo: maleButton.trailingAnchor, constant: 14),
            maleLabel.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -180),
            maleLabel.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -450),

            femaleButton.topAnchor.constraint(equalTo: maleButton.bottomAnchor, constant: 16),
            femaleButton.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 24),
            femaleButton.heightAnchor.constraint(equalToConstant: 16),
            femaleButton.widthAnchor.constraint(equalToConstant: 16),

            femaleLabel.centerYAnchor.constraint(equalTo: femaleButton.centerYAnchor),
            femaleLabel.leadingAnchor.constraint(equalTo: femaleButton.trailingAnchor, constant: 14),
            femaleLabel.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -180),
            femaleLabel.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -420),

            fourthLabel.topAnchor.constraint(equalTo: femaleButton.bottomAnchor, constant: 15),
            fourthLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 24),
            fourthLabel.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -218),
            fourthLabel.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -408),

            fourthTextField.topAnchor.constraint(equalTo: fourthLabel.bottomAnchor, constant: 6),
            fourthTextField.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 24),
            fourthTextField.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -16),
            fourthTextField.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -362),

            fifthLabel.topAnchor.constraint(equalTo: fourthTextField.bottomAnchor, constant: 15),
            fifthLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 24),
            fifthLabel.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -218),
            fifthLabel.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -332),

            fifthTextField.topAnchor.constraint(equalTo: fifthLabel.bottomAnchor, constant: 6),
            fifthTextField.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 24),
            fifthTextField.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -16),
            fifthTextField.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -260)
        ])
    }

    private func addSubviewsForContactsView() {
        view.addSubview(firstLabel)
        view.addSubview(firstTextField)
        view.addSubview(secondLabel)
        view.addSubview(secondTextField)
    }

    private func layoutForContacts() {
        let safeArea = view.safeAreaLayoutGuide

        NSLayoutConstraint.activate([
            firstLabel.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 20),
            firstLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 20),
            firstLabel.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -110),
            firstLabel.heightAnchor.constraint(equalToConstant: 30),

            firstTextField.topAnchor.constraint(equalTo: firstLabel.bottomAnchor, constant: 15),
            firstTextField.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 20),
            firstTextField.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -60),
            firstTextField.heightAnchor.constraint(equalToConstant: 50),

            secondLabel.topAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: 30),
            secondLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 20),
            secondLabel.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -110),
            secondLabel.heightAnchor.constraint(equalToConstant: 30),

            secondTextField.topAnchor.constraint(equalTo: secondLabel.bottomAnchor, constant: 15),
            secondTextField.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 20),
            secondTextField.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -60),
            secondTextField.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    private func addSubviewsForInterests() {
        view.addSubview(firstLabel)
        view.addSubview(firstTextField)
    }

    private func layoutForInterests() {
        let safeArea = view.safeAreaLayoutGuide

        NSLayoutConstraint.activate([
            firstLabel.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 20),
            firstLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 20),
            firstLabel.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -110),
            firstLabel.heightAnchor.constraint(equalToConstant: 30),

            firstTextField.topAnchor.constraint(equalTo: firstLabel.bottomAnchor, constant: 15),
            firstTextField.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 20),
            firstTextField.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -60),
            firstTextField.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    private func addSubViewsForEducation() {
        view.addSubview(firstLabel)
        view.addSubview(firstTextField)
    }

    private func layoutForEducation() {
        let safeArea = view.safeAreaLayoutGuide

        NSLayoutConstraint.activate([
            firstLabel.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 20),
            firstLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 20),
            firstLabel.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -110),
            firstLabel.heightAnchor.constraint(equalToConstant: 30),

            firstTextField.topAnchor.constraint(equalTo: firstLabel.bottomAnchor, constant: 15),
            firstTextField.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 20),
            firstTextField.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -60),
            firstTextField.heightAnchor.constraint(equalToConstant: 50)
        ])
    }


    private func addSubviewsForCareer() {
        view.addSubview(firstLabel)
        view.addSubview(firstTextField)
    }

    private func layoutForCareer() {
        let safeArea = view.safeAreaLayoutGuide

        NSLayoutConstraint.activate([
            firstLabel.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 20),
            firstLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 20),
            firstLabel.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -110),
            firstLabel.heightAnchor.constraint(equalToConstant: 30),

            firstTextField.topAnchor.constraint(equalTo: firstLabel.bottomAnchor, constant: 15),
            firstTextField.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 20),
            firstTextField.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -60),
            firstTextField.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
}
