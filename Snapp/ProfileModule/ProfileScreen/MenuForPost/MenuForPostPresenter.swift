//
//  MenuForPostPresenter.swift
//  Snapp
//
//  Created by Максим Жуин on 20.05.2024.
//

import UIKit
import FirebaseAuth
import Firebase

protocol MenuForPostViewProtocol: AnyObject {
    func showError(descr error: String)
}

protocol MenuForPostPresenterProtocol: AnyObject {
    init(view: MenuForPostViewProtocol, user: FirebaseUser, firestoreService: FireStoreServiceProtocol, post: EachPost)
}

protocol MenuForPostDelegate: AnyObject {
    func pinPost(post: EachPost)
}


final class MenuForPostPresenter: MenuForPostPresenterProtocol {
    weak var view: MenuForPostViewProtocol?
    let user: FirebaseUser
    let firestoreService: FireStoreServiceProtocol
    let post: EachPost
    weak var delegate: MenuForPostDelegate?

    init(view: MenuForPostViewProtocol, user: FirebaseUser, firestoreService: FireStoreServiceProtocol, post: EachPost) {
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
        guard let userID = user.documentID, let docID = post.documentID else { return }
        firestoreService.pinPost(user: userID, docID: docID)
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
}
