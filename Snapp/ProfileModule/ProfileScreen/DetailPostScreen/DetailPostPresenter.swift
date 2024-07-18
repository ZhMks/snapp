//
//  DetailPostPresenter.swift
//  Snapp
//
//  Created by Максим Жуин on 14.05.2024.
//

import UIKit
import FirebaseAuth

enum UserState {
    case mainUser
    case notMainUser
}

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
    func updateBookmarkButton()
}

protocol DetailPostPresenterProtocol: AnyObject {
    init(view: DetailPostViewProtocol, user: FirebaseUser, mainUserID: String, post: EachPost, avatarImage: UIImage, userState: UserState)
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
    let userState: UserState

    init(view: DetailPostViewProtocol, user: FirebaseUser, mainUserID: String, post: EachPost, avatarImage: UIImage, userState: UserState) {
        self.view = view
        self.user = user
        self.post = post
        self.avatarImage = avatarImage
        self.mainUserID = mainUserID
        self.userState = userState
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
        switch userState {
        case .mainUser:
            guard let post = post.documentID else { return }
            FireStoreService.shared.getComments(post: post, user: mainUserID) { [weak self] result in
                guard let self else { return }
                switch result {
                case .success(let commentaries):
                    for comment in commentaries {
                        nsLock.lock()
                        comments?.updateValue(nil, forKey: comment)
                        nsLock.unlock()
                        guard let documentID = comment.documentID else { return }
                        FireStoreService.shared.getAnswers(post: post, comment: documentID, user: mainUserID) { [weak self] result in
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
        case .notMainUser:
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
    }

    func getLikes() {
        switch userState {
        case .mainUser:
            guard let post = post.documentID  else { return }
            FireStoreService.shared.getNumberOfLikesInpost(user: mainUserID, post: post) { [weak self] result in
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
        case .notMainUser:
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
    }

    func updateData() {
        switch userState {
        case .mainUser:
            FireStoreService.shared.getPosts(sub: mainUserID) { [weak self] result in
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
        case .notMainUser:
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
    }

    func showCommetVC(commentID: String?, state: CommentState) {
        view?.showCommentVC(commentID: commentID, state: state)
    }

    func updateComments() {
        view?.updateCommentsState()
    }

    func incrementLikesForPost() {
        switch userState {
        case .mainUser:
            guard let postID = post.documentID else { return }
            FireStoreService.shared.incrementLikesForPost(user: mainUserID, mainUser: mainUserID, post: postID)
            getLikes()
        case .notMainUser:
            guard let postID = post.documentID, let userID = user.documentID else { return }
            FireStoreService.shared.incrementLikesForPost(user: userID, mainUser: mainUserID, post: postID)
            getLikes()
        }
    }

    func decrementLikesForPost() {
        guard let postID = post.documentID, let userID = user.documentID else { return }
        FireStoreService.shared.decrementLikesForPost(user: userID, mainUser: mainUserID, post: postID)
        getLikes()
    }

    func showMenuForPost() {
        view?.showMenuForPost()
    }

    func addPostToBookmarks() {
        switch userState {
        case .mainUser:
            FireStoreService.shared.saveToBookMarks(mainUser: mainUserID, user: mainUserID, post: self.post) { [weak self] result in
                switch result {
                case .success(let success):
                    if success {
                        return
                    } else {
                        self?.view?.showError(descr: "Пост уже сущетсвует")
                    }
                case .failure(let failure):
                    self?.view?.showError(descr: failure.localizedDescription)
                }
            }
            checkBookmarkedPost()
        case .notMainUser:
            guard let userID = user.documentID else { return }
            FireStoreService.shared.saveToBookMarks(mainUser: mainUserID, user: userID, post: self.post) { [weak self] result in
                switch result {
                case .success(let success):
                    if success {
                        return
                    } else {
                        self?.view?.showError(descr: "Пост уже сущетсвует")
                    }
                case .failure(let failure):
                    self?.view?.showError(descr: failure.localizedDescription)
                }
            }
        }
        checkBookmarkedPost()
    }

    func checkBookmarkedPost() {
        switch userState {
        case .mainUser:
            FireStoreService.shared.fetchBookmarkedPosts(user: mainUserID) { [weak self] result in
                switch result {
                case .success(let bookmarkedPosts):
                    if bookmarkedPosts.contains(where: { $0.text == self?.post.text }) {
                        self?.view?.updateBookmarkButton()
                    }
                case .failure(let failure):
                    self?.view?.showError(descr: failure.localizedDescription)
                }
            }
        case .notMainUser:
            guard let userID = user.documentID else { return }
            FireStoreService.shared.fetchBookmarkedPosts(user: userID) { [weak self] result in
                switch result {
                case .success(let bookmarkedPosts):
                    if bookmarkedPosts.contains(where: { $0.text == self?.post.text }) {
                        self?.view?.updateBookmarkButton()
                    }
                case .failure(let failure):
                    self?.view?.showError(descr: failure.localizedDescription)
                }
            }
        }
    }

    func incrementLikesForComment(commentID: String) {
        switch userState {
        case .mainUser:
            guard  let postID = post.documentID else { return }
            print("CommentID for like: \(commentID), userForComment: \(mainUserID), postFOrComment: \(postID), mainUSERID: \(mainUserID)")
            FireStoreService.shared.incrementLikesForComment(commentID: commentID, user: mainUserID, postID: postID, mainUserID: mainUserID)
            fetchComments()
        case .notMainUser:
            guard let userID = self.user.documentID, let postID = post.documentID else { return }
            print("CommentID for like: \(commentID), userForComment: \(userID), postFOrComment: \(postID), mainUSERID: \(mainUserID)")
            FireStoreService.shared.incrementLikesForComment(commentID: commentID, user: userID, postID: postID, mainUserID: mainUserID)
            fetchComments()
        }
    }

    func decrementLikesForComment(commentID: String) {
        switch userState {
        case .mainUser:
            guard let postID = post.documentID else { return }
            FireStoreService.shared.decrementLikesForComment(commentID: commentID, user: mainUserID, postID: postID, mainUserID: mainUserID)
            fetchComments()
        case .notMainUser:
            guard let userID = self.user.documentID, let postID = post.documentID else { return }
            FireStoreService.shared.decrementLikesForComment(commentID: commentID, user: userID, postID: postID, mainUserID: mainUserID)
            fetchComments()
        }
    }

    func incrementLikesForAnswer(answerID: String, commentID: String) {
        switch userState {
        case .mainUser:
            guard let postID = post.documentID else { return }
            FireStoreService.shared.incrementLikesForAnswer(answerID: answerID, user: mainUserID, postID: postID, commentID: commentID, mainUserID: mainUserID)
            fetchComments()
        case .notMainUser:
            guard let userID = self.user.documentID, let postID = post.documentID else { return }
            FireStoreService.shared.incrementLikesForAnswer(answerID: answerID, user: userID, postID: postID, commentID: commentID, mainUserID: mainUserID)
            fetchComments()
        }
    }

    func decrementLikesForAnswer(answerID: String, commentID: String) {
        switch userState {
        case .mainUser:
            guard  let postID = post.documentID else { return }
            FireStoreService.shared.decrementLikesForAnswer(answerID: answerID, user: mainUserID, postID: postID, commentID: commentID, mainUserID: mainUserID)
            fetchComments()
        case .notMainUser:
            guard let userID = self.user.documentID, let postID = post.documentID else { return }
            FireStoreService.shared.decrementLikesForAnswer(answerID: answerID, user: userID, postID: postID, commentID: commentID, mainUserID: mainUserID)
            fetchComments()
        }
    }
}
