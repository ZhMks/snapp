//
//  CreatePostPresenter.swift
//  Snapp
//
//  Created by Максим Жуин on 10.05.2024.
//

import UIKit


protocol CreatePostViewProtocol: AnyObject {
    func showErrorAlert(error: String)
}

protocol CreatePostPresenterProtocol: AnyObject {
    init(view: CreatePostViewProtocol?, mainUser: FirebaseUser, userID: String,  image: UIImage, posts: [EachPost])
    func createPost(text: String, image: UIImage?, completion: @escaping (Result<[EachPost]?, Error>) -> Void)
}

final class CreatePostPresenter: CreatePostPresenterProtocol {

    let mainUser: FirebaseUser
    weak  var view: CreatePostViewProtocol?
    let userID: String
    let image: UIImage
    var posts: [EachPost]
    let nsLock = NSLock()


    init(view: CreatePostViewProtocol?, mainUser: FirebaseUser, userID: String, image: UIImage, posts: [EachPost]) {
        self.mainUser = mainUser
        self.view = view
        self.userID = userID
        self.image = image
        self.posts = posts
    }

    func createPost(text: String, image: UIImage?, completion: @escaping (Result<[EachPost]?, Error>) -> Void) {
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM"
        let stringFromDate = dateFormatter.string(from: date)

        FireStoreService.shared.createPost(date: stringFromDate, text: text, image: image, for: userID) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let firestorePost):
                let eachPost = EachPost(text: firestorePost.text,
                                        image: firestorePost.image,
                                        likes: firestorePost.likes,
                                        commentaries: firestorePost.commentaries,
                                        date: firestorePost.date, isCommentariesEnabled: true,
                                        isPinned: false,
                                        userHoldingPost: userID)
                nsLock.lock()
                posts.append(eachPost)
                nsLock.unlock()
                completion(.success(posts))
            case .failure(let error):
                view?.showErrorAlert(error: error.localizedDescription)
            }
        }
    }
}
