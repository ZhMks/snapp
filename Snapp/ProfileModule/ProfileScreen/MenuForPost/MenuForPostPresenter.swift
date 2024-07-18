//
//  MenuForPostPresenter.swift
//  Snapp
//
//  Created by Максим Жуин on 20.05.2024.
//

import UIKit


protocol MenuForPostViewProtocol: AnyObject {
    func showError(descr error: String)
    func removeMenu()
}

protocol MenuForPostPresenterProtocol: AnyObject {
    init(view: MenuForPostViewProtocol, user: FirebaseUser, post: EachPost, mainUserID: String)
}

protocol MenuForPostDelegate: AnyObject {
    func pinPost()
}


final class MenuForPostPresenter: MenuForPostPresenterProtocol {
    weak var view: MenuForPostViewProtocol?
    let user: FirebaseUser
    let post: EachPost
    weak var delegate: MenuForPostDelegate?
    let mainUserID: String

    init(view: MenuForPostViewProtocol, user: FirebaseUser, post: EachPost, mainUserID: String) {
        self.view = view
        self.user = user
        self.post = post
        self.mainUserID = mainUserID
    }

    func savePostToBookmarks() {
        guard let user = user.documentID else { return }
        FireStoreService.shared.saveToBookMarks(mainUser: user, user: user, post: post) { [weak self] result in
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

    func disableCommentaries() {
        if let documentID = post.documentID {
            FireStoreService.shared.disableCommentaries(id: documentID, user: mainUserID)
        }
    }

    func addPostToArchives() {
        FireStoreService.shared.addDocToArchives(post: post, user: mainUserID) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(_):
                self.view?.removeMenu()
            case .failure(let failure):
                view?.showError(descr: failure.localizedDescription)
            }
        }
    }

    func pinPost() {
        guard let docID = post.documentID else { return }
        FireStoreService.shared.pinPost(user: mainUserID, docID: docID)
        delegate?.pinPost()
    }

    func copyPostLink() -> String {
        if let documentID = post.documentID {
            let urlLink = FireStoreService.shared.getDocLink(for: documentID, user: mainUserID)
            return urlLink
        }
        return ""
    }


    func deletePost() {
        guard let postID = post.documentID else { return }
        FireStoreService.shared.deleteDocument(docID: postID, user: mainUserID) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(_):
                self.view?.removeMenu()
            case .failure(let failure):
                view?.showError(descr: failure.localizedDescription)
            }
        }
    }
}
