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
    func showCommentVC(commentID: String?, state: CommentState)
    func updateCommentsNumber()
    func updateCommentsState()
    func updateLikes()
    func showMenuForPost()
    func showViewControllerWithoutImage()
}

protocol DetailPostPresenterProtocol: AnyObject {
    init(view: DetailPostViewProtocol, user: FirebaseUser, mainUserID: String, post: EachPost, avatarImage: UIImage)
    func updateComments()
}

final class DetailPostPresenter: DetailPostPresenterProtocol {

    weak var view: DetailPostViewProtocol?
    let user: FirebaseUser
    var post: EachPost
    let avatarImage: UIImage
    var comments: [Comment : [Answer]?]?
    var likes: [Like]?
    let mainUserID: String
    let nsLock = NSLock()

    init(view: DetailPostViewProtocol, user: FirebaseUser, mainUserID: String, post: EachPost, avatarImage: UIImage) {
        self.view = view
        self.user = user
        self.post = post
        self.avatarImage = avatarImage
        self.mainUserID = mainUserID
    }

    func fetchPostImage() {
        if let image = post.image {
            if image.isEmpty {
                view?.showViewControllerWithoutImage()
            } else {
                let networkService = NetworkService()
                networkService.fetchImage(string: image) { [weak self] result in
                    guard let self = self else { return }
                    switch result {
                    case .success(let image):
                        self.view?.updateImageView(image: image)
                    case .failure(_):
                        return
                    }
                }
            }
        }
    }

    func fetchComments() {
        updateData()
        comments = [:]
        guard let post = post.documentID else { return }
        guard let user = user.documentID else { return }
        FireStoreService.shared.getComments(post: post, user: user) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let commentaries):
                for comment in commentaries {
                    nsLock.lock()
                    comments?.updateValue(nil, forKey: comment)
                    nsLock.unlock()
                    guard let documentID = comment.documentID else { return }
                    FireStoreService.shared.getAnswers(post: post, comment: documentID, user: user) { [weak self] result in
                        guard let self else { return }
                        switch result {
                        case .success(let answers):
                            nsLock.lock()
                            comments?.updateValue(answers, forKey: comment)
                            nsLock.unlock()
                        case .failure(let failure):
                            view?.showError(descr: failure.localizedDescription)
                        }
                    }
                }
            case .failure(let failure):
                view?.showError(descr: failure.localizedDescription)
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
                guard let self else { return }
                view?.updateCommentsTableView()
            }
        }
    }

    func getLikes() {
        guard let user = user.documentID , let post = post.documentID  else { return }
        FireStoreService.shared.getNumberOfLikesInpost(user: user, post: post) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let success):
                nsLock.lock()
                self.likes = success
                nsLock.unlock()
                view?.updateLikes()
            case .failure(let failure):
                print(failure.localizedDescription)
            }
        }
    }

    func updateData() {
        guard let user = user.documentID else { return }
        FireStoreService.shared.getPosts(sub: user) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let success):
                for eachpost in success {
                    if eachpost.documentID! == post.documentID! {
                        nsLock.lock()
                        self.post = eachpost
                        nsLock.unlock()
                        view?.updateCommentsNumber()
                    }
                }
            case .failure(let failure):
                view?.showError(descr: failure.localizedDescription)
            }
        }
    }

    func showCommetVC(commentID: String?, state: CommentState) {
        view?.showCommentVC(commentID: commentID, state: state)
    }

    func updateComments() {
        view?.updateCommentsState()
    }

    func incrementLikes() {
        guard let postID = post.documentID, let userID = user.documentID else { return }
        FireStoreService.shared.incrementLikes(user: userID, mainUser: mainUserID, post: postID)
        getLikes()
    }

    func decrementLikes() {
        guard let postID = post.documentID, let userID = user.documentID else { return }
        FireStoreService.shared.decrementLikes(user: userID, mainUser: mainUserID, post: postID)
        getLikes()
    }

    func showMenuForPost() {
        view?.showMenuForPost()
    }

}
