//
//  MenuForPostPresenter.swift
//  Snapp
//
//  Created by Максим Жуин on 20.05.2024.
//

import UIKit
import FirebaseAuth

enum MenuState {
    case feedMenu
    case postMenu
}

protocol MenuForPostViewProtocol: AnyObject {
    func successfullySaved()
    func showError(descr error: String)
    func disableComments()
    func addToArchiveSuccess()
    func postIsDeleted()
    func updateViewForFeed()
    func updateViewForPost()
}

protocol MenuForPostPresenterProtocol: AnyObject {
    init(view: MenuForPostViewProtocol, user: FirebaseUser, firestoreService: FireStoreServiceProtocol, post: EachPost, viewState: MenuState)
}


final class MenuForPostPresenter: MenuForPostPresenterProtocol {
    weak var view: MenuForPostViewProtocol?
    let user: FirebaseUser
    let firestoreService: FireStoreServiceProtocol
    let post: EachPost
    let viewState: MenuState

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
            case .success(let success):
                view?.successfullySaved()
            case .failure(let failure):
                view?.showError(descr: failure.localizedDescription)
            }
        }
    }

    func disableCommentaries() {
        guard let user = user.documentID else { return }
        if let documentID = post.documentID {
            firestoreService.disableCommentaries(id: documentID, user: user)
            view?.disableComments()
        }
    }

    func addPostToArchives() {
        guard let user = user.documentID else { return }
        firestoreService.addDocToArchives(post: post, user: user) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let success):
                print(success.image)
                view?.addToArchiveSuccess()
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


    func deletePost() {
        guard let user = user.documentID else { return }
        guard let postID = post.documentID else { return }
        firestoreService.deleteDocument(docID: postID, user: user) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(_):
                view?.postIsDeleted()
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

}
