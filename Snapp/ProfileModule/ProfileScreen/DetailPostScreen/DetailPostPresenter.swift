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
    func showError()
    func updateCommentsTableView()
    func showCommentVC(with: String, commentID: String?)
}

protocol DetailPostPresenterProtocol: AnyObject {
    init(view: DetailPostViewProtocol, user: FirebaseUser, post: EachPost, image: UIImage, firestoreService: FireStoreServiceProtocol)
}

final class DetailPostPresenter: DetailPostPresenterProtocol {

    weak var view: DetailPostViewProtocol?
    let user: FirebaseUser
    let post: EachPost
    let image: UIImage
    var comments: [Comment : [Answer]?]?
    let firestoreService: FireStoreServiceProtocol

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
                    print("success")
                    guard let image = UIImage(data: success) else { return }
                    self.view?.updateImageView(image: image)
                case .failure(let failure):
                    print(failure.localizedDescription)
                }
            }
        }
    }

    func fetchComments() {
        comments = [:]
        guard let post = post.documentID else { return }
        guard let user = user.documentID else { return }
        firestoreService.getComments(post: post, user: user) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let commentaries):
                print(commentaries)
                for comment in commentaries {
                    comments?.updateValue(nil, forKey: comment)
                    guard let documentID = comment.documentID else { return }
                    firestoreService.getAnswers(post: post, comment: documentID, user: user) { [weak self] result in
                        guard let self else { return }
                        switch result {
                        case .success(let answers):
                            print(answers)
                            comments?.updateValue(answers, forKey: comment)
                        case .failure(let failure):
                            view?.showError()
                        }
                    }
                }
            case .failure(let failure):
                view?.showError()
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                self.view?.updateCommentsTableView()
            }
        }
    }

    func showCommetVC(with user: String, commentID: String?) {
        view?.showCommentVC(with: user, commentID: commentID)
    }

}
