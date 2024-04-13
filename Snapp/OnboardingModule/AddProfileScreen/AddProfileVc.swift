//
//  AddProfileVc.swift
//  Snapp
//
//  Created by Максим Жуин on 11.04.2024.
//

import UIKit


final class AddProfileVc: UIViewController {
    // MARK: -PROPERTIES
    var presenter: AddProfilePresenter!

    private lazy var avatarImage: UIImageView = {
        let avatarImage = UIImageView(image: UIImage(systemName: "person.crop.circle"))
        avatarImage.translatesAutoresizingMaskIntoConstraints = false
        avatarImage.tintColor = ColorCreator.shared.createButtonColor()
        avatarImage.layer.cornerRadius = avatarImage.frame.size.width / 2
        avatarImage.clipsToBounds = true
        avatarImage.contentMode = .scaleAspectFill
        return avatarImage
    }()

    private lazy var nameTextField: UITextField = {
        let nameTextField = UITextField()
        nameTextField.borderStyle = .roundedRect
        nameTextField.placeholder = .localized(string: "Введите имя")
        nameTextField.textAlignment = .center
        nameTextField.translatesAutoresizingMaskIntoConstraints = false
        return nameTextField
    }()

    private lazy var surNameTextField: UITextField = {
        let surNameTextField = UITextField()
        surNameTextField.borderStyle = .roundedRect
        surNameTextField.placeholder = .localized(string: "Введите фамилию")
        surNameTextField.textAlignment = .center
        surNameTextField.translatesAutoresizingMaskIntoConstraints = false
        return surNameTextField
    }()

    private lazy var jobNameTextField: UITextField = {
        let surNameTextField = UITextField()
        surNameTextField.borderStyle = .roundedRect
        surNameTextField.placeholder = .localized(string: "Укажите должность")
        surNameTextField.textAlignment = .center
        surNameTextField.translatesAutoresizingMaskIntoConstraints = false
        return surNameTextField
    }()

    private lazy var cityTextField: UITextField = {
        let surNameTextField = UITextField()
        surNameTextField.borderStyle = .roundedRect
        surNameTextField.placeholder = .localized(string: "Укажите город")
        surNameTextField.textAlignment = .center
        surNameTextField.translatesAutoresizingMaskIntoConstraints = false
        return surNameTextField
    }()

    private lazy var interestsTextField: UITextField = {
        let surNameTextField = UITextField()
        surNameTextField.borderStyle = .roundedRect
        surNameTextField.placeholder = .localized(string: "Заполните интересы")
        surNameTextField.textAlignment = .center
        surNameTextField.translatesAutoresizingMaskIntoConstraints = false
        return surNameTextField
    }()

    private lazy var contactsTextField: UITextField = {
        let surNameTextField = UITextField()
        surNameTextField.borderStyle = .roundedRect
        surNameTextField.placeholder = .localized(string: "Укажите контактную информацию")
        surNameTextField.textAlignment = .center
        surNameTextField.translatesAutoresizingMaskIntoConstraints = false
        return surNameTextField
    }()

    private lazy var submitButton: UIButton = {
        let submitButton = UIButton(type: .system)
        submitButton.backgroundColor = ColorCreator.shared.createButtonColor()
        submitButton.translatesAutoresizingMaskIntoConstraints = false
        submitButton.setTitle(.localized(string: "Далее"), for: .normal)
        submitButton.setTitleColor(.systemBackground, for: .normal)
        submitButton.titleLabel?.font = UIFont(name: "Inter-Medium", size: 14)
        submitButton.layer.cornerRadius = 10.0
        submitButton.addTarget(self, action: #selector(submitButtonTapped), for: .touchUpInside)
        return submitButton
    }()

    private lazy var plusButton: UIButton = {
        let submitButton = UIButton(type: .system)
        submitButton.translatesAutoresizingMaskIntoConstraints = false
        submitButton.layer.cornerRadius = 12.0
        submitButton.clipsToBounds = true
        submitButton.setImage(UIImage(systemName: "plus.circle"), for: .normal)
        submitButton.tintColor = .systemYellow
        submitButton.addTarget(self, action: #selector(plusButtonTapped), for: .touchUpInside)
        return submitButton
    }()


    // MARK: -LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        addSubviews()
        layout()
        addGestureToView()
    }

    // MARK: -FUNCS

    @objc func submitButtonTapped() {
        let userModelService = UserCoreDataModelService()
        presenter.createUser(id: self.presenter.fireAuthUser.uid,
                             name: nameTextField.text!,
                             surname: surNameTextField.text!,
                             job: jobNameTextField.text!,
                             city: cityTextField.text!,
                             interests: interestsTextField.text!,
                             contacts: contactsTextField.text!,
                             image: avatarImage.image!) { result in
            switch result {
            case .success(let user):
                print("FIREBASUSER: \(user)")
                self.presenter.firestoreService.getPosts(id:self.presenter.fireAuthUser.uid) { [weak self] result in
                    guard let self else { return }
                    switch result {
                    case .success(let posts):
                        print(self.presenter.fireAuthUser.uid)
                        userModelService.saveModelToCoreData(user: user, id: self.presenter.fireAuthUser.uid, posts: posts) { result in
                            switch result {
                            case .success(let success):
                                print("CoreData: \(success)")
                                self.pushMainScreen(user: success)
                            case .failure(let failure):
                                print()
                            }
                        }
                    case .failure(let failure):
                        print(failure.localizedDescription)
                    }
                }
            case .failure(let failure):
                print(failure.localizedDescription)
            }

        }
    }

    @objc func tapOnView() {
        view.endEditing(true)
    }

    @objc func plusButtonTapped() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .photoLibrary
        present(imagePickerController, animated: true)
    }

    private func pushMainScreen(user: UserMainModel) {
        let feedVC = FeedViewController()
        let feedPresenter = FeedPresenter(view: feedVC, user: user)
        feedVC.presenter = feedPresenter

        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(feedVC, user: user, firestoreService: presenter.firestoreService)
    }
}

// MARK: -OUTPUT PRESENTER
extension AddProfileVc: AddProfileViewProtocol {
    
}


// MARK: -LAYOUT

extension AddProfileVc {

    private func addSubviews() {
        view.addSubview(avatarImage)
        view.addSubview(nameTextField)
        view.addSubview(surNameTextField)
        view.addSubview(jobNameTextField)
        view.addSubview(cityTextField)
        view.addSubview(contactsTextField)
        view.addSubview(interestsTextField)
        view.addSubview(submitButton)
        view.addSubview(plusButton)
    }

    private func layout() {

        let safeArea = view.safeAreaLayoutGuide

        NSLayoutConstraint.activate([
            avatarImage.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 130),
            avatarImage.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -110),
            avatarImage.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 15),
            avatarImage.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -540),

            plusButton.centerYAnchor.constraint(equalTo: avatarImage.bottomAnchor, constant: -10),
            plusButton.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor, constant: 40),


            nameTextField.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 80),
            nameTextField.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -80),
            nameTextField.topAnchor.constraint(equalTo: avatarImage.bottomAnchor, constant: 30),
            nameTextField.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -480),

            surNameTextField.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 80),
            surNameTextField.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -80),
            surNameTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 20),
            surNameTextField.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -420),

            jobNameTextField.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 80),
            jobNameTextField.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -80),
            jobNameTextField.topAnchor.constraint(equalTo: surNameTextField.bottomAnchor, constant: 20),
            jobNameTextField.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -360),

            cityTextField.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 80),
            cityTextField.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -80),
            cityTextField.topAnchor.constraint(equalTo: jobNameTextField.bottomAnchor, constant: 20),
            cityTextField.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -300),

            contactsTextField.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 80),
            contactsTextField.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -80),
            contactsTextField.topAnchor.constraint(equalTo: cityTextField.bottomAnchor, constant: 20),
            contactsTextField.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -250),

            interestsTextField.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 80),
            interestsTextField.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -80),
            interestsTextField.topAnchor.constraint(equalTo: contactsTextField.bottomAnchor, constant: 20),
            interestsTextField.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -140),

            submitButton.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 80),
            submitButton.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -80),
            submitButton.topAnchor.constraint(equalTo: interestsTextField.bottomAnchor, constant: 20),
            submitButton.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -70)
        ])
    }

    private func addGestureToView() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapOnView))
        view.addGestureRecognizer(tapGesture)
    }
}

extension AddProfileVc: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
        avatarImage.image = image
    }

}
