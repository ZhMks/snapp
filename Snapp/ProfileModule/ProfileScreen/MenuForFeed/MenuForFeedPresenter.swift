//
//  MenuForFeedPresenter.swift
//  Snapp
//
//  Created by Максим Жуин on 13.06.2024.
//

import UIKit
import FirebaseAuth


protocol MenuForFeedViewProtocol: AnyObject {
    func showError(descr: String)
    func showActivityController()
    func showReportView()
}

protocol MenuForFeedPresenterProtocol: AnyObject {
    init(view: MenuForFeedViewProtocol, user: FirebaseUser, post: EachPost, mainUserID: String)
}

final class MenuForFeedPresenter: MenuForFeedPresenterProtocol {

    weak var view: MenuForFeedViewProtocol?
    let user: FirebaseUser
    let post: EachPost
    let mainUserID: String

    init(view: MenuForFeedViewProtocol, user: FirebaseUser, post: EachPost, mainUserID: String) {
        self.view = view
        self.user = user
        self.post = post
        self.mainUserID = mainUserID
    }

    func saveIntoBookmarks() {
        guard let userID = user.documentID else { return }
        FireStoreService.shared.saveToBookMarks(mainUser: mainUserID, user: userID, post: post) { [weak self] result in
            switch result {
            case .success(let success):
                if success {
                    return
                } else {
                    self?.view?.showError(descr: "Пост уже существует")
                }
            case .failure(let failure):
                self?.view?.showError(descr: failure.localizedDescription)
            }
        }
    }

    func copyPostLink() -> String {
        guard let user = user.documentID else { return "" }
        if let documentID = post.documentID {
            let urlLink = FireStoreService.shared.getDocLink(for: documentID, user: user)
            return urlLink
        }
        return ""
    }

    func removeSubscribtion() {
        guard let userID = user.documentID else { return }
        FireStoreService.shared.removeSubscribtion(sub: userID, for: mainUserID)
        FireStoreService.shared.removeSubscriber(sub: mainUserID, for: userID)
    }

    func enableNotifications() {
        NotificationsService.shared.registerNotificationCenter {[weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(_):
                let title = "Вы попдписались на пользователя"
                let body = "\(user.name)" + " \(user.surname)"
                NotificationsService.shared.postNotification(title: title, body: body)
            case .failure(_):
                return
            }
        }
    }

    func showReportView() {
        view?.showReportView()
    }

    func presentActivity() {
        view?.showActivityController()
    }

    func sendMail(text: String?) {
        guard let userID = user.documentID, let text = text else { return }
        FireStoreService.shared.addReportToUser(user: userID, text: text)
    }
}
