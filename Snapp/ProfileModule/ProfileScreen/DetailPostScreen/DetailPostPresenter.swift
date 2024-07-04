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

    init(view: DetailPostViewProtocol, user: FirebaseUser, mainUserID: String, post: EachPost, avatarImage: UIImage) {
        self.view = view
        self.user = user
        self.post = post
        self.avatarImage = avatarImage
        self.mainUserID = mainUserID
    }

    func fetchPostImage() {
        if let image = post.image {
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
        view?.showViewControllerWithoutImage()
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
                    comments?.updateValue(nil, forKey: comment)
                    guard let documentID = comment.documentID else { return }
                    FireStoreService.shared.getAnswers(post: post, comment: documentID, user: user) { [weak self] result in
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

    func getLikes() {
        guard let user = user.documentID , let post = post.documentID  else { return }
        FireStoreService.shared.getNumberOfLikesInpost(user: user, post: post) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let success):
                self.likes = success
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
