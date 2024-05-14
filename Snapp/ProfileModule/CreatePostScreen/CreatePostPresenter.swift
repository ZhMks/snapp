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
    init(view: CreatePostViewProtocol?, mainUser: FirebaseUser, userID: String, firestoreService: FireStoreServiceProtocol, image: UIImage, posts: [MainPost])
    func createPost(text: String, image: UIImage?, completion: @escaping (Result<[MainPost]?, Error>) -> Void)
}

final class CreatePostPresenter: CreatePostPresenterProtocol {

    let mainUser: FirebaseUser
    weak  var view: CreatePostViewProtocol?
    let userID: String
    let firestoreService: FireStoreServiceProtocol
    let image: UIImage
    var posts: [MainPost]


    init(view: CreatePostViewProtocol?, mainUser: FirebaseUser, userID: String, firestoreService: any FireStoreServiceProtocol, image: UIImage, posts: [MainPost]) {
        self.mainUser = mainUser
        self.view = view
        self.userID = userID
        self.firestoreService = firestoreService
        self.image = image
        self.posts = posts
    }

    func createPost(text: String, image: UIImage?, completion: @escaping (Result<[MainPost]?, Error>) -> Void) {
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        let stringFromDate = formatter.string(from: date)

        firestoreService.createPost(date: stringFromDate, text: text, image: image, for: userID) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let firestorePost):
                let eachPost = EachPost(text: firestorePost.text,
                                        image: firestorePost.image,
                                        likes: firestorePost.likes,
                                        views: firestorePost.views)
                if posts.isEmpty {
                    var mainPost = MainPost(date: stringFromDate, postsArray: [])
                    mainPost.postsArray.append(eachPost)
                    posts.append(mainPost)
                    completion(.success(posts))
                } else {
                    for var post in posts {
                        if post.date == stringFromDate {
                            post.postsArray.append(eachPost)
                            completion(.success(posts))
                        }
                    }
                }
            case .failure(let error):
                view?.showErrorAlert(error: error.localizedDescription)
            }
        }
    }
}
