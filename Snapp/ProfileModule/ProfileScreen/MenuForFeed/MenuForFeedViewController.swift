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
        addToBookmarkButton.addTarget(self, action: #selector(saveIntoBookmarks), for: .touchUpInside)
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
        reportButton.addTarget(self, action: #selector(reportButtonTapped), for: .touchUpInside)
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
        dismiss(animated: true)
    }

    @objc func saveIntoBookmarks() {
        presenter.saveIntoBookmarks()
        dismiss(animated: true)
    }

    @objc func getDocLink() {
        let doclink =  presenter.copyPostLink()
        let updatedUrlLink = "https://console.firebase.google.com/u/1/project/snappproject-9ca98/firestore/databases/-default-/data/" + doclink
        UIPasteboard.general.url = URL(string: updatedUrlLink)
        dismiss(animated: true)
    }


    @objc func removeSubscribtion() {
        presenter.removeSubscribtion()
        dismiss(animated: true)
    }


    @objc func shareButtonTapped() {
        presenter.presentActivity()
    }

    @objc func reportButtonTapped() {
        presenter.showReportView()
    }

    @objc func infoViewButtonTapped() {
        presenter.removeSubscribtion()
        dismiss(animated: true)
    }
}


//MARK: -Presenter Output

extension MenuForFeedViewController: MenuForFeedViewProtocol {

    func showInfoView() {
        let infoView = UIView(frame: CGRect(x: 50, y: 50, width: 120, height: 120))
        infoView.layer.cornerRadius = 10
        infoView.backgroundColor = .systemBackground
        infoView.layer.shadowColor = UIColor.systemGray3.cgColor
        infoView.layer.shadowOpacity = 1.0
        infoView.layer.shadowRadius = 3.0

        let text = UILabel(frame: CGRect(x: infoView.frame.minX, y: infoView.frame.minY, width: 80, height: 80))
        text.text = "Мы приняли к рассмотрению вашу жалобу, а также скрыли посты данного пользователя от вас"


        let button = UIButton(frame: CGRect(x: text.frame.midX, y: text.frame.maxY, width: 80, height: 40))
        button.setTitle("К поиску", for: .normal)
        button.addTarget(self, action: #selector(infoViewButtonTapped), for: .touchUpInside)
        button.backgroundColor = ColorCreator.shared.createButtonColor()
        infoView.addSubview(text)
        infoView.addSubview(button)
        view.addSubview(infoView)
    }

    func showReportView() {
        let reportAlertController = UIAlertController(title: "String", message: "String", preferredStyle: .alert)
        reportAlertController.addTextField { textField in
            textField.borderStyle = .roundedRect
            textField.placeholder = "Enter Text"
        }
        let uiAction = UIAlertAction(title: .localized(string: "Отправить"), style: .cancel) { [weak self] _ in
            self?.presenter.sendMail(text: reportAlertController.textFields?.first?.text)
        }
        reportAlertController.addAction(uiAction)
        present(reportAlertController, animated: true)
    }
    
    func showActivityController() {
        let urlLink = "https://console.firebase.google.com/u/1/project/snappproject-9ca98/firestore/databases/-default-/data/" + presenter.copyPostLink()
        let activityController = UIActivityViewController(activityItems: [urlLink], applicationActivities: nil)
        present(activityController, animated: true)
    }

    func showError(descr error: String) {
        let uiAlertController = UIAlertController(title: .localized(string: "Ошибка"), message: .localized(string: error), preferredStyle: .alert)
        let uiAlertAction = UIAlertAction(title: .localized(string: "Отмена"), style: .cancel)
        uiAlertController.addAction(uiAlertAction)
        present(uiAlertController, animated: true)
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


