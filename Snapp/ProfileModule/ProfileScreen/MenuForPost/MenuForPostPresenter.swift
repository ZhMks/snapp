//
//  MenuForPostPresenter.swift
//  Snapp
//
//  Created by Максим Жуин on 20.05.2024.
//

import UIKit
import FirebaseAuth
import Firebase

enum MenuState {
    case feedMenu
    case postMenu
}

protocol MenuForPostViewProtocol: AnyObject {
    func showError(descr error: String)
    func updateViewForFeed()
    func updateViewForPost()
}

protocol MenuForPostPresenterProtocol: AnyObject {
    init(view: MenuForPostViewProtocol, user: FirebaseUser, firestoreService: FireStoreServiceProtocol, post: EachPost, viewState: MenuState)
}

protocol MenuForPostDelegate: AnyObject {
    func pinPost(post: EachPost)
    func presentActivity(controller: UIActivityViewController)
}


final class MenuForPostPresenter: MenuForPostPresenterProtocol {
    weak var view: MenuForPostViewProtocol?
    let user: FirebaseUser
    let firestoreService: FireStoreServiceProtocol
    let post: EachPost
    var viewState: MenuState
    weak var delegate: MenuForPostDelegate?

    init(view: MenuForPostViewProtocol, user: FirebaseUser, firestoreService: FireStoreServiceProtocol, post: EachPost, viewState: MenuState) {
        self.view = view
        self.user = user
        self.firestoreService = firestoreService
        self.post = post
        self.viewState = viewState
        checkViewState()
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

    func disableCommentaries() {
        guard let user = user.documentID else { return }
        if let documentID = post.documentID {
            firestoreService.disableCommentaries(id: documentID, user: user)
        }
    }

    func addPostToArchives() {
        guard let user = user.documentID else { return }
        firestoreService.addDocToArchives(post: post, user: user) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(_):
                return
            case .failure(let failure):
                view?.showError(descr: failure.localizedDescription)
            }
        }
    }

    func pinPost(post: EachPost) {
        delegate?.pinPost(post: self.post)
    }

    func copyPostLink() -> String {
        guard let user = user.documentID else { return "" }
        if let documentID = post.documentID {
            let urlLink = firestoreService.getDocLink(for: documentID, user: user)
            return urlLink
        }
        return ""
    }


    func deletePost() {
        guard let user = user.documentID else { return }
        guard let postID = post.documentID else { return }
        firestoreService.deleteDocument(docID: postID, user: user) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(_):
                return
            case .failure(let failure):
                view?.showError(descr: failure.localizedDescription)
            }
        }
    }

    func checkViewState() {
        switch self.viewState {
        case .feedMenu:
            view?.updateViewForFeed()
        case .postMenu:
            view?.updateViewForPost()
        }
    }

    func removeSubscribtion() {
        guard let mainUser = Auth.auth().currentUser?.uid else { return }
        guard let userID = user.documentID else { return }
        firestoreService.removeSubscribtion(sub: userID, for: mainUser)
    }

    func presentActivity(controller: UIActivityViewController) {
        delegate?.presentActivity(controller: controller)
    }

}
