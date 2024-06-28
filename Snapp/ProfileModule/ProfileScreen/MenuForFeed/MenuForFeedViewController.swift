//
//  MenuForFeedViewController.swift
//  Snapp
//
//  Created by Максим Жуин on 13.06.2024.
//

import UIKit

class MenuForFeedViewController: UIViewController {

    // MARK: - Properties
    var presenter: MenuForFeedPresenter!

    private lazy var topSeparatorView: UIView = {
        let topSeparatorView = UIView()
        topSeparatorView.translatesAutoresizingMaskIntoConstraints = false
        topSeparatorView.backgroundColor = ColorCreator.shared.createButtonColor()
        topSeparatorView.layer.cornerRadius = 2.0
        return topSeparatorView
    }()

    private lazy var addToBookmarkButton: UIButton = {
        let addToBookmarkButton = UIButton(type: .system)
        addToBookmarkButton.translatesAutoresizingMaskIntoConstraints = false
        addToBookmarkButton.setTitle(.localized(string: "Сохранить в закладках"), for: .normal)
        addToBookmarkButton.titleLabel?.font = UIFont(name: "Inter-Light", size: 14)
        addToBookmarkButton.setTitleColor(ColorCreator.shared.createTextColor(), for: .normal)
        addToBookmarkButton.contentHorizontalAlignment = .left
        addToBookmarkButton.addTarget(self, action: #selector(saveIntoFavourites), for: .touchUpInside)
        return addToBookmarkButton
    }()

    private lazy var enableNotificationButton: UIButton = {
        let enableNotification = UIButton(type: .system)
        enableNotification.translatesAutoresizingMaskIntoConstraints = false
        enableNotification.setTitle(.localized(string: "Включить уведомления"), for: .normal)
        enableNotification.titleLabel?.font = UIFont(name: "Inter-Light", size: 14)
        enableNotification.setTitleColor(ColorCreator.shared.createTextColor(), for: .normal)
        enableNotification.contentHorizontalAlignment = .left
        enableNotification.addTarget(self, action: #selector(enableNotificationsButtonTapped), for: .touchUpInside)
        return enableNotification
    }()

    private lazy var shareButton: UIButton = {
        let shareButton = UIButton(type: .system)
        shareButton.translatesAutoresizingMaskIntoConstraints = false
        shareButton.setTitle(.localized(string: "Поделиться в ..."), for: .normal)
        shareButton.titleLabel?.font = UIFont(name: "Inter-Light", size: 14)
        shareButton.setTitleColor(ColorCreator.shared.createTextColor(), for: .normal)
        shareButton.contentHorizontalAlignment = .left
        shareButton.addTarget(self, action: #selector(shareButtonTapped), for: .touchUpInside)
        return shareButton
    }()

    private lazy var cancellSubscribtionButton: UIButton = {
        let cancellSubscribtionButton = UIButton(type: .system)
        cancellSubscribtionButton.translatesAutoresizingMaskIntoConstraints = false
        cancellSubscribtionButton.setTitle(.localized(string: "Отменить подписку"), for: .normal)
        cancellSubscribtionButton.titleLabel?.font = UIFont(name: "Inter-Light", size: 14)
        cancellSubscribtionButton.setTitleColor(ColorCreator.shared.createTextColor(), for: .normal)
        cancellSubscribtionButton.contentHorizontalAlignment = .left
        cancellSubscribtionButton.addTarget(self, action: #selector(removeSubscribtion), for: .touchUpInside)
        return cancellSubscribtionButton
    }()

    private lazy var reportButton: UIButton = {
        let reportButton = UIButton(type: .system)
        reportButton.translatesAutoresizingMaskIntoConstraints = false
        reportButton.setTitle(.localized(string: "Пожаловаться"), for: .normal)
        reportButton.titleLabel?.font = UIFont(name: "Inter-Light", size: 14)
        reportButton.setTitleColor(ColorCreator.shared.createTextColor(), for: .normal)
        reportButton.contentHorizontalAlignment = .left
        return reportButton
    }()

    private lazy var saveLinkToPostButton: UIButton = {
        let saveLinkToPost = UIButton(type: .system)
        saveLinkToPost.translatesAutoresizingMaskIntoConstraints = false
        saveLinkToPost.setTitle(.localized(string: "Скопировать ссылку"), for: .normal)
        saveLinkToPost.titleLabel?.font = UIFont(name: "Inter-Light", size: 14)
        saveLinkToPost.setTitleColor(ColorCreator.shared.createTextColor(), for: .normal)
        saveLinkToPost.contentHorizontalAlignment = .left
        saveLinkToPost.addTarget(self, action: #selector(getDocLink), for: .touchUpInside)
        return saveLinkToPost
    }()

    // MARK: -Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = ColorCreator.shared.createPostBackgroundColor()
        view.layer.cornerRadius = 20
        addSubviews()
        layout()
    }

    //MARK: -Funcs

    @objc func enableNotificationsButtonTapped() {

    }

    @objc func saveIntoFavourites() {
        presenter.saveIntoFavourites()
    }

    @objc func getDocLink() {
        let doclink =  presenter.copyPostLink()
        let updatedUrlLink = "https://console.firebase.google.com/u/1/project/snappproject-9ca98/firestore/databases/-default-/data/" + doclink
        UIPasteboard.general.url = URL(string: updatedUrlLink)
    }


    @objc func removeSubscribtion() {
        presenter.removeSubscribtion()
    }


    @objc func shareButtonTapped() {
        presenter.presentActivity()
    }

    @objc func reportButtonTapped() {

    }
}


//MARK: -Presenter Output

extension MenuForFeedViewController: MenuForFeedViewProtocol {
    func showActivityController() {
        let urlLink = "https://console.firebase.google.com/u/1/project/snappproject-9ca98/firestore/databases/-default-/data/" + presenter.copyPostLink()
        let activityController = UIActivityViewController(activityItems: [urlLink], applicationActivities: nil)
        self.navigationController?.present(activityController, animated: true)
    }

    func updateViewForFeed() {


    }

    func showError(descr error: String) {
        print(error)
    }
}


// MARK: -Layout

extension MenuForFeedViewController {

    func addSubviews() {
        view.addSubview(topSeparatorView)
        view.addSubview(addToBookmarkButton)
        view.addSubview(enableNotificationButton)
        view.addSubview(saveLinkToPostButton)
        view.addSubview(shareButton)
        view.addSubview(cancellSubscribtionButton)
        view.addSubview(reportButton)
    }

    func layout() {
        let safeArea = view.safeAreaLayoutGuide

        NSLayoutConstraint.activate([
            topSeparatorView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 30),
            topSeparatorView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 166),
            topSeparatorView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -159),
            topSeparatorView.heightAnchor.constraint(equalToConstant: 3),

            addToBookmarkButton.topAnchor.constraint(equalTo: topSeparatorView.bottomAnchor, constant: 15),
            addToBookmarkButton.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 28),
            addToBookmarkButton.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -184),
            addToBookmarkButton.heightAnchor.constraint(equalToConstant: 20),

            enableNotificationButton.topAnchor.constraint(equalTo: addToBookmarkButton.bottomAnchor, constant: 18),
            enableNotificationButton.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 28),
            enableNotificationButton.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -180),
            enableNotificationButton.heightAnchor.constraint(equalToConstant: 20),

            saveLinkToPostButton.topAnchor.constraint(equalTo: enableNotificationButton.bottomAnchor, constant: 18),
            saveLinkToPostButton.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 28),
            saveLinkToPostButton.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -201),
            saveLinkToPostButton.heightAnchor.constraint(equalToConstant: 20),

            shareButton.topAnchor.constraint(equalTo: saveLinkToPostButton.bottomAnchor, constant: 18),
            shareButton.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 28),
            shareButton.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -239),
            shareButton.heightAnchor.constraint(equalToConstant: 20),

            cancellSubscribtionButton.topAnchor.constraint(equalTo: shareButton.bottomAnchor, constant: 18),
            cancellSubscribtionButton.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 28),
            cancellSubscribtionButton.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -208),
            cancellSubscribtionButton.heightAnchor.constraint(equalToConstant: 20),

            reportButton.topAnchor.constraint(equalTo: cancellSubscribtionButton.bottomAnchor, constant: 18),
            reportButton.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 28),
            reportButton.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -245),
            reportButton.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
}


