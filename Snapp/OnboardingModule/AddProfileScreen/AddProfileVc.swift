//
//  AddProfileVc.swift
//  Snapp
//
//  Created by Максим Жуин on 11.04.2024.
//

import UIKit
import FirebaseAuth

final class AddProfileVc: UIViewController {
    // MARK: -PROPERTIES
    var presenter: AddProfilePresenter!

    private lazy var avatarImage: UIImageView = {
        let avatarImage = UIImageView(image: UIImage(systemName: "person.crop.circle"))
        avatarImage.translatesAutoresizingMaskIntoConstraints = false
        avatarImage.tintColor = ColorCreator.shared.createButtonColor()
        avatarImage.clipsToBounds = true
        avatarImage.contentMode = .scaleToFill
        return avatarImage
    }()

    private lazy var profileView: UIView = {
        let profileView = UIView()
        profileView.translatesAutoresizingMaskIntoConstraints = false
        profileView.layer.shadowColor = UIColor.systemGray2.cgColor
        profileView.layer.shadowOpacity = 1.0
        profileView.layer.shadowRadius = 2.0
        profileView.layer.cornerRadius = 10.0
        profileView.layer.shadowOffset = CGSize(width: 3.0, height: 3.0)
        profileView.backgroundColor = .systemBackground
        return profileView
    }()

    private lazy var nameTextField: UITextField = {
        let nameTextField = UITextField()
        nameTextField.placeholder = .localized(string: "Введите имя")
        nameTextField.textAlignment = .left
        nameTextField.font = UIFont(name: "Inter-Bold", size: 16)
        nameTextField.translatesAutoresizingMaskIntoConstraints = false
        return nameTextField
    }()

    private lazy var separatorView: UIView = {
        let separatorView = UIView()
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        separatorView.backgroundColor = .systemOrange
        return separatorView
    }()

    private lazy var surNameTextField: UITextField = {
        let surNameTextField = UITextField()
        surNameTextField.placeholder = .localized(string: "Введите фамилию")
        surNameTextField.textAlignment = .left
        surNameTextField.font = UIFont(name: "Inter-Bold", size: 16)
        surNameTextField.translatesAutoresizingMaskIntoConstraints = false
        return surNameTextField
    }()

    private lazy var jobNameTextField: UITextField = {
        let jobNameTextField = UITextField()
        jobNameTextField.placeholder = .localized(string: "Укажите должность")
        jobNameTextField.textAlignment = .left
        jobNameTextField.translatesAutoresizingMaskIntoConstraints = false
        jobNameTextField.textColor = .systemOrange
        return jobNameTextField
    }()

    private lazy var identifierTextField: UITextField = {
        let identifierTextField = UITextField()
        identifierTextField.placeholder = .localized(string: "Придумайте уникальный id")
        identifierTextField.textAlignment = .left
        identifierTextField.textColor = .systemOrange
        identifierTextField.translatesAutoresizingMaskIntoConstraints = false
        identifierTextField.keyboardType = .asciiCapable
        return identifierTextField
    }()

    private lazy var submitButton: UIButton = {
        let submitButton = UIButton(type: .system)
        submitButton.backgroundColor = ColorCreator.shared.createButtonColor()
        submitButton.translatesAutoresizingMaskIntoConstraints = false
        submitButton.setTitle(.localized(string: "Выбрать аватар"), for: .normal)
        submitButton.setTitleColor(.systemBackground, for: .normal)
        submitButton.titleLabel?.font = UIFont(name: "Inter-Medium", size: 14)
        submitButton.layer.cornerRadius = 10.0
        submitButton.addTarget(self, action: #selector(pickAvatar), for: .touchUpInside)
        return submitButton
    }()

    private lazy var plusButton: UIButton = {
        let plusButton = UIButton(type: .system)
        plusButton.translatesAutoresizingMaskIntoConstraints = false
        plusButton.layer.cornerRadius = 12.0
        plusButton.backgroundColor = .systemGray5
        plusButton.layer.shadowOffset = CGSize(width: 5.0, height: 5.3)
        plusButton.layer.shadowOpacity = 1.0
        plusButton.layer.shadowRadius = 5.0
        plusButton.layer.shadowColor = UIColor.systemGray2.cgColor
        plusButton.setImage(UIImage(systemName: "arrowshape.right"), for: .normal)
        plusButton.tintColor = ColorCreator.shared.createTextColor()
        plusButton.addTarget(self, action: #selector(submitButtonTapped), for: .touchUpInside)
        plusButton.isEnabled = false
        return plusButton
    }()

    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()


    // MARK: -LIFECYCLE

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupKeyboardObservers()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        addSubviews()
        layout()
        addGestureToView()
        tuneNavItem()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeKeyboardObservers()
    }

    // MARK: -FUNCS

    @objc func submitButtonTapped() {
        presenter.createUser(id: identifierTextField.text!,
                             name: nameTextField.text!,
                             surname: surNameTextField.text!,
                             job: jobNameTextField.text!,
                             image: avatarImage.image!) { [weak self] result in
            guard let self else { return }
            guard let userID = Auth.auth().currentUser?.uid else { return }
            switch result {
            case .success(let user):
                self.plusButtonTapped(user: user, id: userID)
            case .failure(let failure):
                print(failure.localizedDescription)
            }
        }
    }

    @objc func tapOnView() {
        view.endEditing(true)
        if !nameTextField.text!.isEmpty && !surNameTextField.text!.isEmpty && !identifierTextField.text!.isEmpty {
            plusButton.backgroundColor = .systemOrange
            plusButton.isEnabled = true
        }
    }

    func plusButtonTapped(user: FirebaseUser, id: String) {
        let profileVC = ProfileViewController()
        let firestoreService = presenter.firestoreService
        let presenter = ProfilePresenter(view: profileVC, mainUser: user, userID: id, firestoreService: firestoreService!)
        profileVC.presenter = presenter

        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(profileVC, user: user)
    }

   @objc private func pickAvatar() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .photoLibrary
        present(imagePickerController, animated: true)
    }
}

// MARK: -OUTPUT PRESENTER
extension AddProfileVc: AddProfileViewProtocol {
    
}


// MARK: -LAYOUT

extension AddProfileVc {

    private func addSubviews() {
        view.addSubview(avatarImage)
        view.addSubview(profileView)
        view.addSubview(scrollView)
        scrollView.addSubview(profileView)
        profileView.addSubview(jobNameTextField)
        profileView.addSubview(separatorView)
        profileView.addSubview(plusButton)
        profileView.addSubview(nameTextField)
        profileView.addSubview(surNameTextField)
        profileView.addSubview(identifierTextField)
        profileView.addSubview(submitButton)
    }

    private func layout() {

        let safeArea = view.safeAreaLayoutGuide

        NSLayoutConstraint.activate([
            avatarImage.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            avatarImage.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            avatarImage.topAnchor.constraint(equalTo: safeArea.topAnchor),
            avatarImage.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -240),

            scrollView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 290),
            scrollView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 50),
            scrollView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -50),
            scrollView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -30),

            profileView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            profileView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            profileView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            profileView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),

            jobNameTextField.leadingAnchor.constraint(equalTo: profileView.leadingAnchor, constant: 20),
            jobNameTextField.trailingAnchor.constraint(equalTo: profileView.trailingAnchor, constant: -120),
            jobNameTextField.topAnchor.constraint(equalTo: profileView.topAnchor, constant: 25),
            jobNameTextField.bottomAnchor.constraint(equalTo: profileView.bottomAnchor, constant: -350),

            separatorView.topAnchor.constraint(equalTo: jobNameTextField.bottomAnchor, constant: 15),
            separatorView.leadingAnchor.constraint(equalTo: profileView.leadingAnchor, constant: 20),
            separatorView.trailingAnchor.constraint(equalTo: profileView.trailingAnchor, constant: -240),
            separatorView.bottomAnchor.constraint(equalTo: profileView.bottomAnchor, constant: -330),

            nameTextField.leadingAnchor.constraint(equalTo: profileView.leadingAnchor, constant: 20),
            nameTextField.trailingAnchor.constraint(equalTo: profileView.trailingAnchor, constant: -110),
            nameTextField.topAnchor.constraint(equalTo: separatorView.bottomAnchor, constant: 50),
            nameTextField.bottomAnchor.constraint(equalTo: profileView.bottomAnchor, constant: -230),

            plusButton.topAnchor.constraint(equalTo: profileView.topAnchor, constant: 25),
            plusButton.leadingAnchor.constraint(equalTo: jobNameTextField.trailingAnchor, constant: 50),
            plusButton.trailingAnchor.constraint(equalTo: profileView.trailingAnchor, constant: -10),
            plusButton.bottomAnchor.constraint(equalTo: profileView.bottomAnchor, constant: -310),

            surNameTextField.leadingAnchor.constraint(equalTo: profileView.leadingAnchor, constant: 20),
            surNameTextField.trailingAnchor.constraint(equalTo: profileView.trailingAnchor, constant: -110),
            surNameTextField.topAnchor.constraint(equalTo: profileView.topAnchor, constant: 160),
            surNameTextField.bottomAnchor.constraint(equalTo: profileView.bottomAnchor, constant: -160),

            identifierTextField.topAnchor.constraint(equalTo: surNameTextField.bottomAnchor, constant: 20),
            identifierTextField.leadingAnchor.constraint(equalTo: profileView.leadingAnchor, constant: 20),
            identifierTextField.trailingAnchor.constraint(equalTo: profileView.trailingAnchor, constant: -50),
            identifierTextField.bottomAnchor.constraint(equalTo: profileView.bottomAnchor, constant: -120),

            submitButton.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 80),
            submitButton.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -80),
            submitButton.topAnchor.constraint(equalTo: identifierTextField.bottomAnchor, constant: 35),
            submitButton.bottomAnchor.constraint(equalTo: profileView.bottomAnchor, constant: -50)
        ])
    }

    private func addGestureToView() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapOnView))
        view.addGestureRecognizer(tapGesture)
    }

    private func tuneNavItem() {
        let backButton = UIBarButtonItem(image: UIImage(systemName: "arrow.left"), style: .plain, target: self, action: #selector(dismissController))
        backButton.tintColor = .black
        self.navigationItem.leftBarButtonItem = backButton
    }

    @objc func dismissController() {
        navigationController?.popViewController(animated: true)
    }

}

// MARK: -PICKERCONTROLLER
extension AddProfileVc: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
        avatarImage.image = image
    }

}


// MARK: -TEXTFIELDDELEGATE
extension AddProfileVc: UITextFieldDelegate {
    private func setupKeyboardObservers() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(willShowKeyboard(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(willHideKeyboard(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc func willShowKeyboard(_ notificator: NSNotification) {
        let keyboardHeight = (notificator.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.height
        scrollView.contentInset.bottom = keyboardHeight ?? 0.0
    }

    @objc func willHideKeyboard(_ notificator: NSNotification) {
        scrollView.contentInset.bottom = 0.0
    }

    private func removeKeyboardObservers(){
        let notificationCenter = NotificationCenter.default
        notificationCenter.removeObserver(self)
    }
}
