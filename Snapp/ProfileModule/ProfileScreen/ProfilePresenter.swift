//
//  ProfilePresenter.swift
//  Snapp
//
//  Created by Максим Жуин on 08.04.2024.
//

import UIKit


protocol ProfileViewProtocol: AnyObject {
    func showErrorAler(error: String)
    func updateAvatarImage(image: UIImage)
    func updateData(data: [MainPost])
}

protocol ProfilePresenterProtocol: AnyObject {
    init(view: ProfileViewProtocol, mainUser: FirebaseUser, userID: String, firestoreService: FireStoreServiceProtocol)
}

final class ProfilePresenter: ProfilePresenterProtocol {

    weak var view: ProfileViewProtocol?
    var mainUser: FirebaseUser
    var firestoreService: FireStoreServiceProtocol
    var posts: [MainPost] = []
    var image: UIImage?
    let userID: String

    init(view: ProfileViewProtocol, mainUser: FirebaseUser, userID: String, firestoreService: FireStoreServiceProtocol) {
        self.view = view
        self.mainUser = mainUser
        self.firestoreService = firestoreService
        self.userID = userID
        fetchImage()
        fetchPosts()
    }

    func createPost(text: String, image: UIImage, completion: @escaping (Result<[MainPost]?, Error>) -> Void) {
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
                view?.showErrorAler(error: error.localizedDescription)
            }
        }
    }

    func fetchImage()  {
        let urlLink = mainUser.image
        let networkService = NetworkService()
        networkService.fetchImage(string: urlLink) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let data):
                guard let image = UIImage(data: data) else { return }
                self.image = image
                view?.updateAvatarImage(image: image)
            case .failure(let failure):
                view?.showErrorAler(error: failure.localizedDescription)
            }
        }
    }

    func fetchPosts() {
        firestoreService.getPosts(sub: userID) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let success):
                self.posts = success
                print(self.posts)
                view?.updateData(data: self.posts)
            case .failure(let failure):
                print()
            }
        }
    }
}
