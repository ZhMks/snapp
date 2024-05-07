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
     //   guard let documentID = mainUser.documentID else { return }
        let eachPost = EachPost(text: "Обязательно вступите в группу курса в Телеграм группа PRO, вся оперативная информация там, но на первой неделе мы будем присылать рассылку о новых уроках", image: "https://firebasestorage.googleapis.com/v0/b/snappproject-9ca98.appspot.com/o/users%2Fposts%2F04-05-2024%2Flicensed-image.jpeg?alt=media&token=d3993a41-0ac8-47f8-a951-432dd9ee9405", likes: 12, views: 12)
        let eachPostsec = EachPost(text: "Обязательно вступите в группу курса в Телеграм группа PRO, вся оперативная информация там, но на первой неделе мы будем присылать рассылку о новых уроках", image: "https://firebasestorage.googleapis.com/v0/b/snappproject-9ca98.appspot.com/o/users%2Fposts%2F04-05-2024%2Flicensed-image.jpeg?alt=media&token=d3993a41-0ac8-47f8-a951-432dd9ee9405", likes: 12, views: 12)
        let eachPostthir = EachPost(text: "SimpleText", image: "https://firebasestorage.googleapis.com/v0/b/snappproject-9ca98.appspot.com/o/users%2Fposts%2F04-05-2024%2Flicensed-image.jpeg?alt=media&token=d3993a41-0ac8-47f8-a951-432dd9ee9405", likes: 12, views: 12)
        let eachPostfor = EachPost(text: "SimpleText", image: "https://firebasestorage.googleapis.com/v0/b/snappproject-9ca98.appspot.com/o/users%2FuuptdvnyBrcXwovEv3U69uxMD7m1%2Favatar?alt=media&token=32020d11-35ff-4be8-b96f-009bccb28d4a", likes: 12, views: 12)
        let eachPostfif = EachPost(text: "SimpleText", image: "https://firebasestorage.googleapis.com/v0/b/snappproject-9ca98.appspot.com/o/users%2FuuptdvnyBrcXwovEv3U69uxMD7m1%2Favatar?alt=media&token=32020d11-35ff-4be8-b96f-009bccb28d4a", likes: 12, views: 12)
        let eachPostsix = EachPost(text: "SimpleText", image: "https://firebasestorage.googleapis.com/v0/b/snappproject-9ca98.appspot.com/o/users%2Fposts%2F04-05-2024%2Flicensed-image.jpeg?alt=media&token=d3993a41-0ac8-47f8-a951-432dd9ee9405", likes: 12, views: 12)
        let mainPost = MainPost(date: "04-05-2024", postsArray: [eachPost, eachPostsec, eachPostthir, eachPostfor, eachPostfif, eachPostsix])
let mainPosts = [mainPost]
        self.posts = mainPosts
        print(self.posts.count)
//        view?.updateData(data: self.posts)
//        firestoreService.getPosts(sub: documentID) { [weak self] result in
//            guard let self else { return }
//            switch result {
//            case .success(let success):
//                self.posts = success
//                print(self.posts)
//                view?.updateData(data: self.posts)
//            case .failure(let failure):
//                print()
//            }
//        }
    }
}
