//
//  SettingsViewController.swift
//  Snapp
//
//  Created by Максим Жуин on 08.04.2024.
//

import UIKit

class SettingsViewController: UIViewController {

    //MARK: -PROPERTIES
    var presenter: SettingPresenter!

    private lazy var nameAndSurnameLabel: UILabel = {
        let nameAndSurnameLabel = UILabel()
        nameAndSurnameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameAndSurnameLabel.text = .localized(string: "\(presenter.user.name)" + "\(presenter.user.surname)")
        nameAndSurnameLabel.textColor = ColorCreator.shared.createTextColor()
        nameAndSurnameLabel.font = UIFont(name: "Inter-Medium", size: 18)
        return nameAndSurnameLabel
    }()

    private lazy var separatorView: UIView = {
        let separatorView = UIView()
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        separatorView.backgroundColor = .systemGray2
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
        bookmarks.setTitleColor(ColorCreator.shared.createTextColor(), for: .normal)
        return bookmarks
    }()

    private lazy var heartImageView: UIView = {
        let heartImageView = UIImageView()
        heartImageView.translatesAutoresizingMaskIntoConstraints = false
        heartImageView.image = UIImage(systemName: "heart")
        heartImageView.tintColor = ColorCreator.shared.createButtonColor()
        return heartImageView
    }()

    private lazy var likedButton: UIButton = {
        let likedButton = UIButton()
        likedButton.translatesAutoresizingMaskIntoConstraints = false
        likedButton.setTitle(.localized(string: "Понравилось"), for: .normal)
        likedButton.setTitleColor(ColorCreator.shared.createTextColor(), for: .normal)
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
        uploadButton.setTitleColor(ColorCreator.shared.createTextColor(), for: .normal)
        uploadButton.translatesAutoresizingMaskIntoConstraints = false
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
        archiveButton.setTitleColor(ColorCreator.shared.createTextColor(), for: .normal)
        archiveButton.translatesAutoresizingMaskIntoConstraints = false
        return archiveButton
    }()

    private lazy var middleSeparatorView: UIView = {
        let middleSeparatorView = UIView()
        middleSeparatorView.translatesAutoresizingMaskIntoConstraints = false
        middleSeparatorView.backgroundColor = .systemGray2
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
        settingsButton.setTitleColor(ColorCreator.shared.createTextColor(), for: .normal)
        settingsButton.translatesAutoresizingMaskIntoConstraints = false
        return settingsButton
    }()


    //MARK: -LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .yellow
        tuneNavItem()
        addSubviews()
        layout()
    }

    //MARK: -FUNCS

    func tuneNavItem() {
        let leftArrowButton = UIBarButtonItem(image: UIImage(systemName: "arrow.left"), style: .plain, target: self, action: #selector(dismissViewController))
        navigationItem.leftBarButtonItem = leftArrowButton
    }

    @objc func dismissViewController() {

    }

}

// MARK: -OUTPUTPRESENTER
extension SettingsViewController: SettingsViewProtocol {

}


// MARK: -LAYOUT
extension SettingsViewController {

    func addSubviews() {
        view.addSubview(nameAndSurnameLabel)
        view.addSubview(separatorView)
        view.addSubview(starImageView)
        view.addSubview(bookmarksButton)
        view.addSubview(heartImageView)
        view.addSubview(likedButton)
        view.addSubview(uploadImageView)
        view.addSubview(uploadButton)
        view.addSubview(archiveImageView)
        view.addSubview(archiveButton)
        view.addSubview(middleSeparatorView)
        view.addSubview(settingsImageView)
        view.addSubview(settingsButton)
    }

    func layout() {
        let safeArea = view.safeAreaLayoutGuide

        NSLayoutConstraint.activate([
            nameAndSurnameLabel.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 25),
            nameAndSurnameLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 30),
            nameAndSurnameLabel.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -101),
            nameAndSurnameLabel.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -703),

            separatorView.topAnchor.constraint(equalTo: nameAndSurnameLabel.bottomAnchor, constant: 18),
            separatorView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 30),
            separatorView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -30),
            separatorView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -685),

            starImageView.topAnchor.constraint(equalTo: separatorView.bottomAnchor, constant: 13),
            starImageView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 30),
            starImageView.heightAnchor.constraint(equalToConstant: 15),
            starImageView.widthAnchor.constraint(equalToConstant: 15),

            bookmarksButton.topAnchor.constraint(equalTo: separatorView.bottomAnchor, constant: 13),
            bookmarksButton.leadingAnchor.constraint(equalTo: starImageView.trailingAnchor, constant: 14),
            bookmarksButton.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -110),
            bookmarksButton.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -650),

            heartImageView.topAnchor.constraint(equalTo: starImageView.bottomAnchor, constant: 18),
            heartImageView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 33),
            heartImageView.heightAnchor.constraint(equalToConstant: 15),
            heartImageView.widthAnchor.constraint(equalToConstant: 15),

            likedButton.topAnchor.constraint(equalTo: bookmarksButton.bottomAnchor, constant: 18),
            likedButton.leadingAnchor.constraint(equalTo: heartImageView.trailingAnchor, constant: 14),
            likedButton.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -110),
            likedButton.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -613),

            uploadImageView.topAnchor.constraint(equalTo: heartImageView.bottomAnchor, constant: 18),
            uploadImageView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 30),
            uploadImageView.heightAnchor.constraint(equalToConstant: 15),
            uploadImageView.widthAnchor.constraint(equalToConstant: 15),

            uploadButton.topAnchor.constraint(equalTo: likedButton.bottomAnchor, constant: 18),
            uploadButton.leadingAnchor.constraint(equalTo: uploadImageView.trailingAnchor, constant: 14),
            uploadButton.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -110),
            uploadButton.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -574),

            archiveImageView.topAnchor.constraint(equalTo: uploadImageView.bottomAnchor, constant: 18),
            archiveImageView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 30),
            archiveImageView.heightAnchor.constraint(equalToConstant: 15),
            archiveImageView.widthAnchor.constraint(equalToConstant: 15),

            archiveButton.topAnchor.constraint(equalTo: uploadButton.bottomAnchor, constant: 18),
            archiveButton.leadingAnchor.constraint(equalTo: archiveImageView.trailingAnchor, constant: 14),
            archiveButton.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -110),
            archiveButton.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -538),

            middleSeparatorView.topAnchor.constraint(equalTo: archiveButton.bottomAnchor, constant: 20),
            middleSeparatorView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 30),
            middleSeparatorView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -30),
            middleSeparatorView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -516),

            settingsImageView.topAnchor.constraint(equalTo: middleSeparatorView.bottomAnchor, constant: 18),
            settingsImageView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 30),
            settingsImageView.heightAnchor.constraint(equalToConstant: 15),
            settingsImageView.widthAnchor.constraint(equalToConstant: 15),

            settingsButton.topAnchor.constraint(equalTo: middleSeparatorView.bottomAnchor, constant: 20),
            settingsButton.leadingAnchor.constraint(equalTo: settingsImageView.trailingAnchor, constant: 14),
            settingsButton.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -110),
            settingsButton.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -481)

        ])
    }

}
