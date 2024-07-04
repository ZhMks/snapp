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
    func updateViewForFeed()
    func showActivityController()
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

    func saveIntoFavourites() {
        guard let user = user.documentID else { return }
        FireStoreService.shared.saveIntoFavourites(post: post, for: user) { [weak self] result in
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
    }

    func enableNotifications() {

    }

    func showReportView() {
        
    }

    func presentActivity() {
        view?.showActivityController()
    }

}
