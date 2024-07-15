//
//  SettingsViewController.swift
//  Snapp
//
//  Created by Максим Жуин on 08.04.2024.
//

import UIKit

protocol SwitchViewControllerDelegate: AnyObject {
    func switchToFavourites()
}

class MainSettingsViewController: UIViewController {

    //MARK: -PROPERTIES
    var presenter: MainSettingsPresenter!
    weak var delegate: SwitchViewControllerDelegate?

    override var prefersStatusBarHidden: Bool {
        return true
    }

    private lazy var mainView: UIView = {
        let mainView = UIView()
        mainView.translatesAutoresizingMaskIntoConstraints = false
        mainView.backgroundColor = ColorCreator.shared.createPostBackgroundColor()
        return mainView
    }()

    private lazy var leftArrowButton: UIButton = {
        let leftArrowButton = UIButton(type: .system)
        leftArrowButton.setBackgroundImage(UIImage(systemName: "arrow.left"), for: .normal)
        leftArrowButton.tintColor = .systemOrange
        leftArrowButton.translatesAutoresizingMaskIntoConstraints = false
        leftArrowButton.addTarget(self, action: #selector(dismissViewController), for: .touchUpInside)
        return leftArrowButton
    }()

    private lazy var nameAndSurnameLabel: UILabel = {
        let nameAndSurnameLabel = UILabel()
        nameAndSurnameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameAndSurnameLabel.text = .localized(string: "\(presenter.user.name)" + " \(presenter.user.surname)")
        nameAndSurnameLabel.textColor = ColorCreator.shared.createTextColor()
        nameAndSurnameLabel.font = UIFont(name: "Inter-Medium", size: 18)
        return nameAndSurnameLabel
    }()

    private lazy var separatorView: UIView = {
        let separatorView = UIView()
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        separatorView.backgroundColor = ColorCreator.shared.createTextColor()
        return separatorView
    }()

    private lazy var starImageView: UIImageView = {
        let starImageView = UIImageView()
        starImageView.translatesAutoresizingMaskIntoConstraints = false
        starImageView.tintColor = .systemOrange
        starImageView.image = UIImage(systemName: "star")
        return starImageView
    }()

    private lazy var bookmarksButton: UIButton = {
        let bookmarks = UIButton(type: .system)
        bookmarks.translatesAutoresizingMaskIntoConstraints = false
        bookmarks.setTitle(.localized(string: "Закладки"), for: .normal)
        bookmarks.contentHorizontalAlignment = .left
        bookmarks.setTitleColor(ColorCreator.shared.createTextColor(), for: .normal)
        bookmarks.addTarget(self, action: #selector(bookmarksButtonTapped), for: .touchUpInside)
        return bookmarks
    }()

    private lazy var heartImageView: UIView = {
        let heartImageView = UIImageView()
        heartImageView.translatesAutoresizingMaskIntoConstraints = false
        heartImageView.image = UIImage(systemName: "heart")
        heartImageView.tintColor = ColorCreator.shared.createButtonColor()
        return heartImageView
    }()

    private lazy var favouritesButton: UIButton = {
        let likedButton = UIButton(type: .system)
        likedButton.translatesAutoresizingMaskIntoConstraints = false
        likedButton.setTitle(.localized(string: "Понравилось"), for: .normal)
        likedButton.contentHorizontalAlignment = .left
        likedButton.setTitleColor(ColorCreator.shared.createTextColor(), for: .normal)
        likedButton.addTarget(self, action: #selector(favouritesButtonTapped), for: .touchUpInside)
        return likedButton
    }()

    private lazy var uploadImageView: UIImageView = {
        let uploadImage = UIImageView()
        uploadImage.image = UIImage(systemName: "square.and.arrow.up")
        uploadImage.translatesAutoresizingMaskIntoConstraints = false
        uploadImage.tintColor = ColorCreator.shared.createButtonColor()
        return uploadImage
    }()

    private lazy var uploadButton: UIButton = {
        let uploadButton = UIButton(type: .system)
        uploadButton.setTitle(.localized(string: "Файлы"), for: .normal)
        uploadButton.contentHorizontalAlignment = .left
        uploadButton.setTitleColor(ColorCreator.shared.createTextColor(), for: .normal)
        uploadButton.translatesAutoresizingMaskIntoConstraints = false
        uploadButton.addTarget(self, action: #selector(uploadButtonTapped), for: .touchUpInside)
        return uploadButton
    }()

    private lazy var archiveImageView: UIImageView = {
        let archiveImage = UIImageView()
        archiveImage.image = UIImage(systemName: "link")
        archiveImage.tintColor = ColorCreator.shared.createButtonColor()
        archiveImage.translatesAutoresizingMaskIntoConstraints = false
        return archiveImage
    }()

    private lazy var archiveButton: UIButton = {
        let archiveButton = UIButton(type: .system)
        archiveButton.setTitle(.localized(string: "Архивы"), for: .normal)
        archiveButton.contentHorizontalAlignment = .left
        archiveButton.setTitleColor(ColorCreator.shared.createTextColor(), for: .normal)
        archiveButton.translatesAutoresizingMaskIntoConstraints = false
        archiveButton.addTarget(self, action: #selector(archiveButtonTapped), for: .touchUpInside)
        return archiveButton
    }()

    private lazy var middleSeparatorView: UIView = {
        let middleSeparatorView = UIView()
        middleSeparatorView.translatesAutoresizingMaskIntoConstraints = false
        middleSeparatorView.backgroundColor = ColorCreator.shared.createTextColor()
        return middleSeparatorView
    }()

    private lazy var settingsImageView: UIImageView = {
        let settingsImageView = UIImageView()
        settingsImageView.image = UIImage(systemName: "gearshape")
        settingsImageView.translatesAutoresizingMaskIntoConstraints = false
        settingsImageView.tintColor = ColorCreator.shared.createButtonColor()
        return settingsImageView
    }()

    private lazy var settingsButton: UIButton = {
        let settingsButton = UIButton(type: .system)
        settingsButton.setTitle(.localized(string: "Настройки"), for: .normal)
        settingsButton.contentHorizontalAlignment = .left
        settingsButton.setTitleColor(ColorCreator.shared.createTextColor(), for: .normal)
        settingsButton.translatesAutoresizingMaskIntoConstraints = false
        settingsButton.addTarget(self, action: #selector(settingsButtonTapped), for: .touchUpInside)
        return settingsButton
    }()


    //MARK: -LIFECYCLE

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNeedsStatusBarAppearanceUpdate()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = ColorCreator.shared.createBackgroundColorWithAlpah(alpha: 0.5)
        tuneNavItem()
        addSubviews()
        layout()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.isHidden = false
    }

    //MARK: -FUNCS

    func tuneNavItem() {
        navigationController?.navigationBar.isHidden = true
    }

    @objc func dismissViewController() {
       dismiss(animated: true)
    }

    @objc func bookmarksButtonTapped() {
        guard let user = self.presenter.user.documentID else { return }
        let bookmarkedVC = BookmarksViewController()
        let bookmarkedPresenter = BookmarksPresenter(view: bookmarkedVC, user: self.presenter.user, mainUser: user)
        bookmarkedVC.presenter = bookmarkedPresenter

        self.navigationController?.pushViewController(bookmarkedVC, animated: true)
    }

    @objc func favouritesButtonTapped() {
        self.dismiss(animated: true) { [weak self] in
            self?.delegate?.switchToFavourites()
        }
    }

    @objc func archiveButtonTapped() {
        guard let mainUserID = presenter.user.documentID else { return }
        let archiveVC = ArchiveViewController()
        let archivePresenter = ArchivePresenter(view: archiveVC, user: presenter.user, mainUser: mainUserID)
        archiveVC.presenter = archivePresenter
        self.navigationController?.pushViewController(archiveVC, animated: true)
    }

    @objc func settingsButtonTapped() {
        let settingsChangeScreen = SettingChangeViewController()
        let settingChangePresenter = SettingChangePresenter(view: settingsChangeScreen)
        settingsChangeScreen.presenter = settingChangePresenter
        self.navigationController?.pushViewController(settingsChangeScreen, animated: true)
    }

    @objc func uploadButtonTapped() {
        let filesViewController = FilesViewController()
        guard let mainUserID = presenter.user.documentID else { return }
        let filesPresenter = FilesPresenter(view: filesViewController, mainUser: presenter.user)
        filesViewController.presenter = filesPresenter
        self.navigationController?.pushViewController(filesViewController, animated: true)
    }

}

// MARK: -OUTPUTPRESENTER
extension MainSettingsViewController: MainSettingsViewProtocol {

}


// MARK: -LAYOUT
extension MainSettingsViewController {

    func addSubviews() {
        view.addSubview(mainView)
        mainView.addSubview(nameAndSurnameLabel)
        mainView.addSubview(leftArrowButton)
        mainView.addSubview(separatorView)
        mainView.addSubview(starImageView)
        mainView.addSubview(bookmarksButton)
        mainView.addSubview(heartImageView)
        mainView.addSubview(favouritesButton)
        mainView.addSubview(uploadImageView)
        mainView.addSubview(uploadButton)
        mainView.addSubview(archiveImageView)
        mainView.addSubview(archiveButton)
        mainView.addSubview(middleSeparatorView)
        mainView.addSubview(settingsImageView)
        mainView.addSubview(settingsButton)
    }

    func layout() {
        let safeArea = view.safeAreaLayoutGuide

        NSLayoutConstraint.activate([

            mainView.topAnchor.constraint(equalTo: view.topAnchor),
            mainView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 62),
            mainView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            mainView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            leftArrowButton.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 15),
            leftArrowButton.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: 30),
            leftArrowButton.heightAnchor.constraint(equalToConstant: 30),
            leftArrowButton.widthAnchor.constraint(equalToConstant: 35),

            nameAndSurnameLabel.topAnchor.constraint(equalTo: leftArrowButton.bottomAnchor, constant: 25),
            nameAndSurnameLabel.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: 30),
            nameAndSurnameLabel.trailingAnchor.constraint(equalTo: mainView.trailingAnchor, constant: -101),
            nameAndSurnameLabel.heightAnchor.constraint(equalToConstant: 22),

            separatorView.topAnchor.constraint(equalTo: nameAndSurnameLabel.bottomAnchor, constant: 18),
            separatorView.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: 30),
            separatorView.trailingAnchor.constraint(equalTo: mainView.trailingAnchor, constant: -30),
            separatorView.heightAnchor.constraint(equalToConstant: 1),

            starImageView.topAnchor.constraint(equalTo: separatorView.bottomAnchor, constant: 13),
            starImageView.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: 30),
            starImageView.heightAnchor.constraint(equalToConstant: 15),
            starImageView.widthAnchor.constraint(equalToConstant: 15),

            bookmarksButton.centerYAnchor.constraint(equalTo: starImageView.centerYAnchor),
            bookmarksButton.leadingAnchor.constraint(equalTo: starImageView.trailingAnchor, constant: 14),
            bookmarksButton.trailingAnchor.constraint(equalTo: mainView.trailingAnchor, constant: -110),
            bookmarksButton.heightAnchor.constraint(equalToConstant: 22),

            heartImageView.topAnchor.constraint(equalTo: starImageView.bottomAnchor, constant: 18),
            heartImageView.centerXAnchor.constraint(equalTo: starImageView.centerXAnchor),
            heartImageView.heightAnchor.constraint(equalToConstant: 15),
            heartImageView.widthAnchor.constraint(equalToConstant: 15),

            favouritesButton.centerYAnchor.constraint(equalTo: heartImageView.centerYAnchor),
            favouritesButton.leadingAnchor.constraint(equalTo: heartImageView.trailingAnchor, constant: 14),
            favouritesButton.trailingAnchor.constraint(equalTo: mainView.trailingAnchor, constant: -110),
            favouritesButton.heightAnchor.constraint(equalToConstant: 22),

            uploadImageView.topAnchor.constraint(equalTo: heartImageView.bottomAnchor, constant: 18),
            uploadImageView.centerXAnchor.constraint(equalTo: heartImageView.centerXAnchor),
            uploadImageView.heightAnchor.constraint(equalToConstant: 15),
            uploadImageView.widthAnchor.constraint(equalToConstant: 15),

            uploadButton.centerYAnchor.constraint(equalTo: uploadImageView.centerYAnchor),
            uploadButton.leadingAnchor.constraint(equalTo: uploadImageView.trailingAnchor, constant: 14),
            uploadButton.trailingAnchor.constraint(equalTo: mainView.trailingAnchor, constant: -110),
            uploadButton.heightAnchor.constraint(equalToConstant: 22),

            archiveImageView.topAnchor.constraint(equalTo: uploadImageView.bottomAnchor, constant: 18),
            archiveImageView.centerXAnchor.constraint(equalTo: uploadImageView.centerXAnchor),
            archiveImageView.heightAnchor.constraint(equalToConstant: 15),
            archiveImageView.widthAnchor.constraint(equalToConstant: 15),

            archiveButton.centerYAnchor.constraint(equalTo: archiveImageView.centerYAnchor),
            archiveButton.leadingAnchor.constraint(equalTo: archiveImageView.trailingAnchor, constant: 14),
            archiveButton.trailingAnchor.constraint(equalTo: mainView.trailingAnchor, constant: -110),
            archiveButton.heightAnchor.constraint(equalToConstant: 22),

            middleSeparatorView.topAnchor.constraint(equalTo: archiveButton.bottomAnchor, constant: 20),
            middleSeparatorView.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: 30),
            middleSeparatorView.trailingAnchor.constraint(equalTo: mainView.trailingAnchor, constant: -30),
            middleSeparatorView.heightAnchor.constraint(equalToConstant: 1),

            settingsImageView.topAnchor.constraint(equalTo: middleSeparatorView.bottomAnchor, constant: 18),
            settingsImageView.centerXAnchor.constraint(equalTo: archiveImageView.centerXAnchor),
            settingsImageView.heightAnchor.constraint(equalToConstant: 15),
            settingsImageView.widthAnchor.constraint(equalToConstant: 15),

            settingsButton.centerYAnchor.constraint(equalTo: settingsImageView.centerYAnchor),
            settingsButton.leadingAnchor.constraint(equalTo: settingsImageView.trailingAnchor, constant: 14),
            settingsButton.trailingAnchor.constraint(equalTo: mainView.trailingAnchor, constant: -110),
            settingsButton.heightAnchor.constraint(equalToConstant: 22)

        ])
    }

}
