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
    init(view: MenuForFeedViewProtocol, user: FirebaseUser, firestoreService: FireStoreServiceProtocol, post: EachPost)
}

final class MenuForFeedPresenter: MenuForFeedPresenterProtocol {

    weak var view: MenuForFeedViewProtocol?
    let user: FirebaseUser
    let firestoreService: FireStoreServiceProtocol
    let post: EachPost

    init(view: MenuForFeedViewProtocol, user: FirebaseUser, firestoreService: FireStoreServiceProtocol, post: EachPost) {
        self.view = view
        self.user = user
        self.firestoreService = firestoreService
        self.post = post
    }

    func saveIntoFavourites() {
        guard let user = user.documentID else { return }
        firestoreService.saveIntoFavourites(post: post, for: user) { [weak self] result in
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
            let urlLink = firestoreService.getDocLink(for: documentID, user: user)
            return urlLink
        }
        return ""
    }

    func removeSubscribtion() {
        guard let mainUser = Auth.auth().currentUser?.uid else { return }
        guard let userID = user.documentID else { return }
        firestoreService.removeSubscribtion(sub: userID, for: mainUser)
    }

    func enableNotifications() {

    }

    func showReportView() {
        
    }

    func presentActivity() {
        view?.showActivityController()
    }

}
