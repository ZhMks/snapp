//
//  MenuForPostViewController.swift
//  Snapp
//
//  Created by Максим Жуин on 20.05.2024.
//

import UIKit

class MenuForPostView: UIView {

    // MARK: -PROPERTIES

    var presenter: MenuForPostPresenter!

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
        return enableNotification
    }()

    private lazy var shareButton: UIButton = {
        let shareButton = UIButton(type: .system)
        shareButton.translatesAutoresizingMaskIntoConstraints = false
        shareButton.setTitle(.localized(string: "Поделиться в ..."), for: .normal)
        shareButton.titleLabel?.font = UIFont(name: "Inter-Light", size: 14)
        shareButton.setTitleColor(ColorCreator.shared.createTextColor(), for: .normal)
        shareButton.contentHorizontalAlignment = .left
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

    private lazy var pinPostButton: UIButton = {
        let pinPostButton = UIButton(type: .system)
        pinPostButton.translatesAutoresizingMaskIntoConstraints = false
        pinPostButton.setTitle(.localized(string: "Закрепить"), for: .normal)
        pinPostButton.titleLabel?.font = UIFont(name: "Inter-Light", size: 14)
        pinPostButton.setTitleColor(ColorCreator.shared.createTextColor(), for: .normal)
        pinPostButton.contentHorizontalAlignment = .left
        return pinPostButton
    }()

    private lazy var disableComment: UIButton = {
        let disableComment = UIButton(type: .system)
        disableComment.translatesAutoresizingMaskIntoConstraints = false
        disableComment.setTitle(.localized(string: "Выключить комментирование"), for: .normal)
        disableComment.titleLabel?.font = UIFont(name: "Inter-Light", size: 14)
        disableComment.setTitleColor(ColorCreator.shared.createTextColor(), for: .normal)
        disableComment.contentHorizontalAlignment = .left
        disableComment.addTarget(self, action: #selector(disableCommentaries), for: .touchUpInside)
        return disableComment
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

    private lazy var addPostToArchive: UIButton = {
        let addPostToArchive = UIButton(type: .system)
        addPostToArchive.translatesAutoresizingMaskIntoConstraints = false
        addPostToArchive.setTitle(.localized(string: "Архивировать запись"), for: .normal)
        addPostToArchive.titleLabel?.font = UIFont(name: "Inter-Light", size: 14)
        addPostToArchive.setTitleColor(ColorCreator.shared.createTextColor(), for: .normal)
        addPostToArchive.contentHorizontalAlignment = .left
        addPostToArchive.addTarget(self, action: #selector(addToArchives), for: .touchUpInside)
        return addPostToArchive
    }()

    private lazy var deletePost: UIButton = {
        let deletePost = UIButton(type: .system)
        deletePost.translatesAutoresizingMaskIntoConstraints = false
        deletePost.setTitle(.localized(string: "Удалить"), for: .normal)
        deletePost.titleLabel?.font = UIFont(name: "Inter-Light", size: 14)
        deletePost.setTitleColor(ColorCreator.shared.createTextColor(), for: .normal)
        deletePost.contentHorizontalAlignment = .left
        deletePost.addTarget(self, action: #selector(deleteDoc), for: .touchUpInside)
        return deletePost
    }()
    // MARK: -LIFECYCLE

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = ColorCreator.shared.createPostBackgroundColor()
        layer.cornerRadius = 10
        addGesture()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //MARK: -FUNCS

    func addGesture() {
        let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(swipeGesture))
        swipeGesture.direction = .down
        self.addGestureRecognizer(swipeGesture)
    }

    @objc func saveIntoFavourites() {
        presenter.saveIntoFavourites()
    }

    @objc func disableCommentaries() {
        presenter.disableCommentaries()
    }

    @objc func getDocLink() {
         let link =  presenter.copyPostLink()
         print(link)
        let pasteBoard = UIPasteboard.general
        pasteBoard.string = link
    }

    @objc func addToArchives() {
        presenter.addPostToArchives()
    }

    @objc func deleteDoc() {
        presenter.deletePost()
    }

    @objc func removeSubscribtion() {
        presenter.removeSubscribtion()
    }

    @objc func swipeGesture() {
        UIView.animate(withDuration: 0.5) {
            self.removeFromSuperview()
        }
    }
}


//MARK: -OUTPUTPRESENTER

extension MenuForPostView: MenuForPostViewProtocol {
    

    func updateViewForFeed() {
        layer.cornerRadius = 10
        addSubview(topSeparatorView)
        addSubview(addToBookmarkButton)
        addSubview(enableNotificationButton)
        addSubview(saveLinkToPostButton)
        addSubview(shareButton)
        addSubview(cancellSubscribtionButton)
        addSubview(reportButton)

        let safeArea = safeAreaLayoutGuide

        NSLayoutConstraint.activate([
            topSeparatorView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 30),
            topSeparatorView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 166),
            topSeparatorView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -159),
            topSeparatorView.heightAnchor.constraint(equalToConstant: 2),

            addToBookmarkButton.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 50),
            addToBookmarkButton.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 28),
            addToBookmarkButton.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -184),
            addToBookmarkButton.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -210),

            enableNotificationButton.topAnchor.constraint(equalTo: addToBookmarkButton.bottomAnchor, constant: 18),
            enableNotificationButton.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 28),
            enableNotificationButton.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -180),
            enableNotificationButton.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -172),

            saveLinkToPostButton.topAnchor.constraint(equalTo: enableNotificationButton.bottomAnchor, constant: 18),
            saveLinkToPostButton.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 28),
            saveLinkToPostButton.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -201),
            saveLinkToPostButton.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -134),

            shareButton.topAnchor.constraint(equalTo: saveLinkToPostButton.bottomAnchor, constant: 18),
            shareButton.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 28),
            shareButton.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -239),
            shareButton.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -96),

            cancellSubscribtionButton.topAnchor.constraint(equalTo: shareButton.bottomAnchor, constant: 18),
            cancellSubscribtionButton.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 28),
            cancellSubscribtionButton.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -208),
            cancellSubscribtionButton.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -58),

            reportButton.topAnchor.constraint(equalTo: cancellSubscribtionButton.bottomAnchor, constant: 18),
            reportButton.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 28),
            reportButton.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -245),
            reportButton.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -20)
        ])

    }

    func updateViewForPost() {
        addSubviews()
        layout()
    }

    func showError(descr error: String) {
        print(error)
    }

}


// MARK: -LAYOUT

extension MenuForPostView {

    func addSubviews() {
        addSubview(addToBookmarkButton)
        addSubview(pinPostButton)
        addSubview(disableComment)
        addSubview(saveLinkToPostButton)
        addSubview(addPostToArchive)
        addSubview(deletePost)
    }

    func layout() {
        let safeArea = safeAreaLayoutGuide

        NSLayoutConstraint.activate([
            addToBookmarkButton.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 20),
            addToBookmarkButton.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 20),
            addToBookmarkButton.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -60),
            addToBookmarkButton.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -240),

            pinPostButton.topAnchor.constraint(equalTo: addToBookmarkButton.bottomAnchor, constant: 18),
            pinPostButton.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 20),
            pinPostButton.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -180),
            pinPostButton.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -182),

            disableComment.topAnchor.constraint(equalTo: pinPostButton.bottomAnchor, constant: 18),
            disableComment.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 20),
            disableComment.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -30),
            disableComment.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -144),

            saveLinkToPostButton.topAnchor.constraint(equalTo: disableComment.bottomAnchor, constant: 18),
            saveLinkToPostButton.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 20),
            saveLinkToPostButton.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -100),
            saveLinkToPostButton.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -106),

            addPostToArchive.topAnchor.constraint(equalTo: saveLinkToPostButton.bottomAnchor, constant: 18),
            addPostToArchive.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 20),
            addPostToArchive.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -70),
            addPostToArchive.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -60),

            deletePost.topAnchor.constraint(equalTo: addPostToArchive.bottomAnchor, constant: 18),
            deletePost.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 20),
            deletePost.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -210),
            deletePost.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -30)
        ])
    }

}
