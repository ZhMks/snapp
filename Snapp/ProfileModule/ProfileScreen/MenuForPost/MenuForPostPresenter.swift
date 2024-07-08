//
//  MenuForPostPresenter.swift
//  Snapp
//
//  Created by Максим Жуин on 20.05.2024.
//

import UIKit


protocol MenuForPostViewProtocol: AnyObject {
    func showError(descr error: String)
}

protocol MenuForPostPresenterProtocol: AnyObject {
    init(view: MenuForPostViewProtocol, user: FirebaseUser, post: EachPost)
}

protocol MenuForPostDelegate: AnyObject {
    func pinPost()
}


final class MenuForPostPresenter: MenuForPostPresenterProtocol {
    weak var view: MenuForPostViewProtocol?
    let user: FirebaseUser
    let post: EachPost
    weak var delegate: MenuForPostDelegate?

    init(view: MenuForPostViewProtocol, user: FirebaseUser, post: EachPost) {
        self.view = view
        self.user = user
        self.post = post
    }

    func savePostToBookmarks() {
        guard let user = user.documentID else { return }
        FireStoreService.shared.saveToBookMarks(mainUser: user, user: user, post: post)
    }

    func disableCommentaries() {
        guard let user = user.documentID else { return }
        if let documentID = post.documentID {
            FireStoreService.shared.disableCommentaries(id: documentID, user: user)
        }
    }

    func addPostToArchives() {
        guard let user = user.documentID else { return }
        FireStoreService.shared.addDocToArchives(post: post, user: user) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(_):
                return
            case .failure(let failure):
                view?.showError(descr: failure.localizedDescription)
            }
        }
    }

    func pinPost() {
        guard let userID = user.documentID, let docID = post.documentID else { return }
        FireStoreService.shared.pinPost(user: userID, docID: docID)
        delegate?.pinPost()
    }

    func copyPostLink() -> String {
        guard let user = user.documentID else { return "" }
        if let documentID = post.documentID {
            let urlLink = FireStoreService.shared.getDocLink(for: documentID, user: user)
            return urlLink
        }
        return ""
    }


    func deletePost() {
        guard let user = user.documentID else { return }
        guard let postID = post.documentID else { return }
        FireStoreService.shared.deleteDocument(docID: postID, user: user) { [weak self] result in
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
