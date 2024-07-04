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
    func showInfoView()
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
        FireStoreService.shared.saveToBookMarks(user: mainUserID, post: post) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(_):
                return
            case .failure(let failure):
                view?.showError(descr: failure.localizedDescription)
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
        view?.showInfoView()
    }
}
