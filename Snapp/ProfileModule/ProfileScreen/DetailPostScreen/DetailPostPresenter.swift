//
//  DetailPostPresenter.swift
//  Snapp
//
//  Created by Максим Жуин on 14.05.2024.
//

import UIKit
import FirebaseAuth

protocol DetailPostViewProtocol: AnyObject {
    func updateImageView(image: UIImage)
    func showError(descr: String)
    func updateCommentsTableView()
    func showCommentVC(with: String, commentID: String?, state: CommentState)
    func updateCommentsNumber()
}

protocol DetailPostPresenterProtocol: AnyObject {
    init(view: DetailPostViewProtocol, user: FirebaseUser, post: EachPost, image: UIImage, firestoreService: FireStoreServiceProtocol)
}

final class DetailPostPresenter: DetailPostPresenterProtocol {

    weak var view: DetailPostViewProtocol?
    let user: FirebaseUser
    var post: EachPost
    let image: UIImage
    var comments: [Comment : [Answer]?]?
    let firestoreService: FireStoreServiceProtocol
    var state: MenuState?

    init(view: DetailPostViewProtocol, user: FirebaseUser, post: EachPost, image: UIImage, firestoreService: FireStoreServiceProtocol) {
        self.view = view
        self.user = user
        self.post = post
        self.image = image
        self.firestoreService = firestoreService
        fetchPostImage()
    }

    func fetchPostImage() {
        if let image = post.image {
            let networkService = NetworkService()
            networkService.fetchImage(string: image) { [weak self] result in
                guard let self else { return }
                switch result {
                case .success(let success):
                    guard let image = UIImage(data: success) else { return }
                    self.view?.updateImageView(image: image)
                case .failure(let failure):
                    print(failure.localizedDescription)
                }
            }
        }
    }

    func fetchComments() {
        updateData()
        comments = [:]
        guard let post = post.documentID else { return }
        guard let user = user.documentID else { return }
        firestoreService.getComments(post: post, user: user) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let commentaries):
                for comment in commentaries {
                    comments?.updateValue(nil, forKey: comment)
                    guard let documentID = comment.documentID else { return }
                    firestoreService.getAnswers(post: post, comment: documentID, user: user) { [weak self] result in
                        guard let self else { return }
                        switch result {
                        case .success(let answers):
                            comments?.updateValue(answers, forKey: comment)
                        case .failure(let failure):
                            view?.showError(descr: failure.localizedDescription)
                        }
                    }
                }
            case .failure(let failure):
                view?.showError(descr: failure.localizedDescription)
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
                guard let self else { return }
                view?.updateCommentsTableView()
            }
        }
    }

    func updateData() {
        guard let user = user.documentID else { return }
        firestoreService.getPosts(sub: user) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let success):
                for eachpost in success {
                    if eachpost.documentID! == post.documentID! {
                        self.post = eachpost
                        view?.updateCommentsNumber()
                    }
                }
            case .failure(let failure):
                view?.showError(descr: failure.localizedDescription)
            }
        }
    }

    func showCommetVC(with user: String, commentID: String?, state: CommentState) {
        view?.showCommentVC(with: user, commentID: commentID, state: state)
    }

    func addlistener() {
        guard let docID = post.documentID else { return }
        guard let userID = user.documentID else { return }
        firestoreService.addSnapshotListenerToCurrentPost(docID: docID, userID: userID) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let currentPost):
                view?.updateCommentsTableView()
            case .failure(let failure):
                view?.showError(descr: failure.localizedDescription)
            }
        }
    }

    func removeListener() {
        firestoreService.removeListenerForCurrentPost()
    }

}
