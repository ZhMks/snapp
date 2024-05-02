//
//  ProfileViewController.swift
//  Snapp
//
//  Created by Максим Жуин on 08.04.2024.
//

import UIKit

class ProfileViewController: UIViewController {
// MARK: -PROPERTIES
    var presenter: ProfilePresenter!

    private lazy var avatarImageView: UIImageView = {
        let avatarImageView = UIImageView()
        avatarImageView.clipsToBounds = true
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        return avatarImageView
    }()

    private lazy var nameAndSurnameLabel: UILabel = {
        let nameAndSurnameLabel = UILabel()
        nameAndSurnameLabel.font = UIFont(name: "Inter-Medium", size: 18)
        nameAndSurnameLabel.textColor = .systemOrange
        nameAndSurnameLabel.text = "Test Text" + "Test TextSurname"
        nameAndSurnameLabel.translatesAutoresizingMaskIntoConstraints = false
        return nameAndSurnameLabel
    }()

    private lazy var jobLabel: UILabel = {
        let jobLabel = UILabel()
        jobLabel.font = UIFont(name: "Inter-Medium", size: 12)
        jobLabel.textColor = .systemGray2
        jobLabel.text = "testjob"
        jobLabel.translatesAutoresizingMaskIntoConstraints = false
        return jobLabel
    }()

    private lazy var detailInfo: UIButton = {
        let detailInfo = UIButton(type: .system)
        detailInfo.translatesAutoresizingMaskIntoConstraints = false
        detailInfo.setTitle(.localized(string: "Подробная информация"), for: .normal)
        detailInfo.setTitleColor(ColorCreator.shared.createTextColor(), for: .normal)
        detailInfo.titleLabel?.font = UIFont(name: "Inter-Medium", size: 14)
        return detailInfo
    }()

    private lazy var signalImage: UIImageView = {
        let signalImage = UIImageView()
        signalImage.translatesAutoresizingMaskIntoConstraints = false
        signalImage.tintColor = .systemOrange
        return signalImage
    }()

    private lazy var editButton: UIButton = {
        let editButton = UIButton(type: .system)
        editButton.translatesAutoresizingMaskIntoConstraints = false
        editButton.titleLabel?.font = UIFont(name: "Inter-Medium", size: 16)
        editButton.setTitleColor(.white, for: .normal)
        editButton.setTitle(.localized(string: "Редактировать"), for: .normal)
        editButton.backgroundColor = .systemOrange
        editButton.layer.cornerRadius = 10.0
        return editButton
    }()

    private lazy var numberOfPosts: UILabel = {
        let numberOfPosts = UILabel()
        numberOfPosts.font = UIFont(name: "Inter-Medium", size: 14)
        numberOfPosts.text = .localized(string: """
        \(presenter.posts?.count)
        Постов
        """)
        numberOfPosts.translatesAutoresizingMaskIntoConstraints = false
        numberOfPosts.textColor = .systemOrange
        return numberOfPosts
    }()

    private lazy var numberOfSubscriptions: UILabel = {
        let numberOfSubscriptions = UILabel()
        numberOfSubscriptions.font = UIFont(name: "Inter-Medium", size: 14)
        numberOfSubscriptions.text = .localized(string: """
        \(presenter.mainUser.subscribers.count)
        Подписок
        """)
        numberOfSubscriptions.translatesAutoresizingMaskIntoConstraints = false
        return numberOfSubscriptions
    }()

    private lazy var numberOfSubscribers: UILabel = {
        let numberOfSubscribers = UILabel()
        numberOfSubscribers.font = UIFont(name: "Inter-Medium", size: 14)
        numberOfSubscriptions.text = .localized(string: """
        \(presenter.mainUser.subscribtions.count)
        Подписчиков
        """)
        numberOfSubscribers.translatesAutoresizingMaskIntoConstraints = false
        return numberOfSubscribers
    }()

    private lazy var separatorView: UIView = {
        let separatorView = UIView()
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        separatorView.backgroundColor = .systemGray2
        return separatorView
    }()

    private lazy var createPostView: UIView = {
        let createPostView = UIView()
        createPostView.translatesAutoresizingMaskIntoConstraints = false
        return createPostView
    }()

    private lazy var createPostButton: UIButton = {
        let createPostButton = UIButton(type: .system)
        createPostButton.setBackgroundImage(UIImage(named: "createPostButton"), for: .normal)
        createPostButton.translatesAutoresizingMaskIntoConstraints = false
        return createPostButton
    }()

    private lazy var createPostLabel: UILabel = {
        let createPostLabel = UILabel()
        createPostLabel.text = .localized(string: "Запись")
        createPostLabel.font = UIFont(name: "Inter-Medium", size: 14)
        createPostLabel.textColor = ColorCreator.shared.createTextColor()
        createPostLabel.translatesAutoresizingMaskIntoConstraints = false
        return createPostLabel
    }()

    private lazy var createStorieView: UIView = {
        let createStorieView = UIView()
        createStorieView.translatesAutoresizingMaskIntoConstraints = false
        return createStorieView
    }()

    private lazy var createStorieButton: UIButton = {
        let createStorieButton = UIButton(type: .system)
        createStorieButton.setBackgroundImage(UIImage(systemName: "camera"), for: .normal)
        createStorieButton.translatesAutoresizingMaskIntoConstraints = false
        return createStorieButton
    }()

    private lazy var createStorieLabel: UILabel = {
        let createStorieLabel = UILabel()
        createStorieLabel.text = .localized(string: "История")
        createStorieLabel.textColor = ColorCreator.shared.createTextColor()
        createStorieLabel.font = UIFont(name: "Inter-Medium", size: 14)
        return createStorieLabel
    }()

    private lazy var addPhotoView: UIView = {
        let addPhotoView = UIView()
        addPhotoView.translatesAutoresizingMaskIntoConstraints = false
        return addPhotoView
    }()

    private lazy var addPhotoButton: UIButton = {
        let addPhotoButton = UIButton(type: .system)
        addPhotoButton.setBackgroundImage(UIImage(systemName: "photo"), for: .normal)
        addPhotoButton.translatesAutoresizingMaskIntoConstraints = false
        return addPhotoButton
    }()

    private lazy var addPhotoLabel: UILabel = {
        let addPhotoLabel = UILabel()
        addPhotoLabel.text = .localized(string: "Фото")
        addPhotoLabel.textColor = ColorCreator.shared.createTextColor()
        addPhotoLabel.font = UIFont(name: "Inter-Medium", size: 14)
        return addPhotoLabel
    }()



// MARK: -LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        tuneNavItem()
        addSubviews()
        layout()
        print(presenter.mainUser.documentID)
    }
    
// MARK: -FUNCS
    @objc func createPostButtonTapped() {
        let text = "TestPostText"
        let image = UIImage(systemName: "checkmark")
        presenter.createPost(text: text, image: image!) { result in
            switch result {
            case .success(let postMainModel):
                print()
            case .failure(let failure):
                print(failure.localizedDescription)
            }
        }
    }

}

// MARK: -OUTPUT PRESENTER
extension ProfileViewController: ProfileViewProtocol {
    func showErrorAler(error: String) {
        print("ShowAlert")
    }
}


// MARK: -LAYOUT
extension ProfileViewController {
    func tuneNavItem() {
        let settingsButton = UIBarButtonItem(image: UIImage(systemName: "line.3.horizontal"),
                                             style: .plain,
                                             target: self,
                                             action: #selector(showSettingsVC))
        settingsButton.tintColor = .systemYellow
        self.navigationItem.rightBarButtonItem = settingsButton

        let textView = UIView(frame: CGRect(x: 0, y: 0, width: 80, height: 30))
        let title = UILabel(frame: CGRect(x: 0, y: 0, width: 80, height: 30))
        title.text = presenter.mainUser.identifier
        title.font = UIFont(name: "Inter-Medium", size: 14)
        textView.addSubview(title)
        let leftButton = UIBarButtonItem(customView: textView)
        self.navigationItem.leftBarButtonItem = leftButton
    }

    @objc func showSettingsVC() {
//        let settingsVC = SettingsViewController()
//        let settingsPresenter = SettingPresenter(view: settingsVC, user: presenter.firebaseUser, firestoreService: presenter.firestoreService)
//        settingsVC.presenter = settingsPresenter
//        navigationController?.present(settingsVC, animated: true)
    }

    func addSubviews() {
        view.addSubview(avatarImageView)
        view.addSubview(nameAndSurnameLabel)
        view.addSubview(jobLabel)
        view.addSubview(signalImage)
        view.addSubview(detailInfo)
        view.addSubview(editButton)
        view.addSubview(numberOfPosts)
        view.addSubview(numberOfSubscribers)
        view.addSubview(numberOfSubscriptions)
        view.addSubview(separatorView)
//        view.addSubview(createPostView)
//        createPostView.addSubview(createPostButton)
//        createPostView.addSubview(createPostLabel)
//        view.addSubview(createStorieView)
//        createStorieView.addSubview(createStorieButton)
//        createStorieView.addSubview(createStorieLabel)
//        view.addSubview(addPhotoView)
//        addPhotoView.addSubview(addPhotoButton)
//        addPhotoView.addSubview(addPhotoLabel)

    }

    func layout() {
        let safeArea = view.safeAreaLayoutGuide

        NSLayoutConstraint.activate([
            avatarImageView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 14),
            avatarImageView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 26),
            avatarImageView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -290),
            avatarImageView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -590),

            nameAndSurnameLabel.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 22),
            nameAndSurnameLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 10),
            nameAndSurnameLabel.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -143),
            nameAndSurnameLabel.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -590),

            jobLabel.topAnchor.constraint(equalTo: nameAndSurnameLabel.bottomAnchor, constant: 3),
            jobLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 10),
            jobLabel.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -221),
            jobLabel.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -500),

            signalImage.topAnchor.constraint(equalTo: jobLabel.bottomAnchor, constant: 5),
            signalImage.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: -10),
            signalImage.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -260),
            signalImage.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -490),

            detailInfo.topAnchor.constraint(equalTo: jobLabel.bottomAnchor, constant: 5),
            detailInfo.leadingAnchor.constraint(equalTo: signalImage.trailingAnchor, constant: 8),
            detailInfo.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -76),
            detailInfo.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -490),

            editButton.topAnchor.constraint(equalTo: detailInfo.bottomAnchor, constant: 25),
            editButton.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 16),
            editButton.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -16),
            editButton.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -460),

            numberOfPosts.topAnchor.constraint(equalTo: editButton.bottomAnchor, constant: 15),
            numberOfPosts.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 16),
            numberOfPosts.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -256),
            numberOfPosts.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -420),

            numberOfSubscriptions.topAnchor.constraint(equalTo: editButton.bottomAnchor, constant: 15),
            numberOfSubscriptions.leadingAnchor.constraint(equalTo: numberOfPosts.trailingAnchor, constant: 25),
            numberOfSubscriptions.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -149),
            numberOfSubscriptions.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -420),

            numberOfSubscribers.topAnchor.constraint(equalTo: editButton.bottomAnchor, constant: 15),
            numberOfSubscribers.leadingAnchor.constraint(equalTo: numberOfSubscriptions.trailingAnchor, constant: 25),
            numberOfSubscribers.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -16),
            numberOfSubscribers.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -420),

            separatorView.topAnchor.constraint(equalTo: numberOfPosts.bottomAnchor, constant: 4),
            separatorView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 16),
            separatorView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: 16),
            separatorView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -410)
        ])
    }
}
