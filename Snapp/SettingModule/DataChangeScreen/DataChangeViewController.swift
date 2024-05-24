//
//  DataChangeViewController.swift
//  Snapp
//
//  Created by Максим Жуин on 21.05.2024.
//

import UIKit

class DataChangeViewController: UIViewController {

    //MARK: -PROPERTIES
    var presenter: DataChangePresenter!

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
        firstTextField.backgroundColor = .systemGray6
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
        secondTextField.placeholder = .localized(string: "Имя")
        secondTextField.textColor = ColorCreator.shared.createTextColor()
        secondTextField.layer.cornerRadius = 8
        secondTextField.backgroundColor = .systemGray6
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

    private lazy var fourthLabel: UILabel = {
        let fourthLabel = UILabel()
        fourthLabel.translatesAutoresizingMaskIntoConstraints = false
        fourthLabel.font = UIFont(name: "Inter-Medium", size: 12)
        fourthLabel.text = .localized(string: "Дата")
        fourthLabel.textColor = ColorCreator.shared.createTextColor()
        return fourthLabel
    }()

    private lazy var fourthTextField: UITextField = {
        let fourthTextField = UITextField()
        fourthTextField.translatesAutoresizingMaskIntoConstraints = false
        fourthTextField.placeholder = .localized(string: "Дата рождения")
        fourthTextField.textColor = ColorCreator.shared.createTextColor()
        fourthTextField.layer.cornerRadius = 8
        fourthTextField.backgroundColor = .systemGray6
        return fourthTextField
    }()

    private lazy var fifthLabel: UILabel = {
        let fifthLabel = UILabel()
        fifthLabel.translatesAutoresizingMaskIntoConstraints = false
        fifthLabel.font = UIFont(name: "Inter-Medium", size: 12)
        fifthLabel.text = .localized(string: "Родной город")
        fifthLabel.textColor = ColorCreator.shared.createTextColor()
        return fifthLabel
    }()

    private lazy var fifthTextField: UITextField = {
        let fifthTextField = UITextField()
        fifthTextField.translatesAutoresizingMaskIntoConstraints = false
        fifthTextField.placeholder = .localized(string: "Город")
        fifthTextField.textColor = ColorCreator.shared.createTextColor()
        fifthTextField.layer.cornerRadius = 8
        fifthTextField.backgroundColor = .systemGray6
        return fifthTextField
    }()

    //MARK: -LIFECYCLE

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        tuneNavItem()
    }

    //MARK: -FUNCS

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

        let textView = UIView(frame: CGRect(x: 0, y: 0, width: 350, height: 30))
        let title = UILabel(frame: CGRect(x: 40, y: 0, width: 250, height: 30))
        title.text = .localized(string: "Основная информация")
        title.font = UIFont(name: "Inter-Medium", size: 14)
        textView.addSubview(title)
        textView.addSubview(leftArrowButton)
        let leftButton = UIBarButtonItem(customView: textView)
        self.navigationItem.leftBarButtonItem = leftButton
    }

    @objc func acceptButtonTapped() async {
        if firstTextField.text!.isEmpty && secondTextField.text!.isEmpty && fourthTextField.text!.isEmpty && fifthTextField.text!.isEmpty {
         dismiss(animated: true)
        } else if firstTextField.text!.isEmpty && secondTextField.text!.isEmpty && fourthTextField.text!.isEmpty {
            await presenter.changeCity(text: fifthTextField.text!)
            dismiss(animated: true)
        } else if firstTextField.text!.isEmpty && secondTextField.text!.isEmpty {
            await presenter.changeSurnamet(text: fourthTextField.text!)
            dismiss(animated: true)
        } else if firstTextField.text!.isEmpty {
            await presenter.changeSurnamet(text: secondTextField.text!)
            dismiss(animated: true)
        } else {
            await presenter.changeName(text: firstTextField.text!)
        }
    }

    @objc func cancelButtonTapped() {
        dismiss(animated: true)
    }
}


// MARK: -PRESENTEROUTPUT
extension DataChangeViewController: DataChangeViewProtocol {

    func layoutForInformationView() {
        addSubviews()
        layout()
    }
    
    func layoutForContactsView() {
        print()
    }
    
    func layoutForInterestsView() {
        print()
    }
    
    func layoutForEducationView() {
        print()
    }
    
    func layoutForCareerView() {
        print()
    }
    

}


//MARK: -LAYOUT
extension DataChangeViewController {

    func addSubviews() {
        view.addSubview(firstLabel)
        view.addSubview(firstTextField)
        view.addSubview(secondLabel)
        view.addSubview(secondTextField)
        view.addSubview(thirdLabel)
        view.addSubview(fourthLabel)
        view.addSubview(fourthTextField)
        view.addSubview(fifthLabel)
        view.addSubview(fifthTextField)
    }

    func layout() {
        let safeArea = view.safeAreaLayoutGuide

        NSLayoutConstraint.activate([
            firstLabel.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 29),
            firstLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 24),
            firstLabel.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -300),
            firstLabel.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -620),

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

            thirdLabel.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 179),
            thirdLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 24),
            thirdLabel.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -298),
            thirdLabel.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -517),

            fourthLabel.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 287),
            fourthLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 24),
            fourthLabel.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -298),
            fourthLabel.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -408),

            fourthTextField.topAnchor.constraint(equalTo: fourthLabel.bottomAnchor, constant: 6),
            fourthTextField.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 24),
            fourthTextField.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -16),
            fourthTextField.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -362),

            fifthLabel.topAnchor.constraint(equalTo: fourthTextField.bottomAnchor, constant: 15),
            fifthLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 24),
            fifthLabel.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -298),
            fifthLabel.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -332),

            fifthTextField.topAnchor.constraint(equalTo: fifthLabel.bottomAnchor, constant: 6),
            fifthTextField.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 24),
            fifthTextField.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -16),
            fifthTextField.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -260)
        ])
    }

}
