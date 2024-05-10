//
//  DetailPresenter.swift
//  Snapp
//
//  Created by Максим Жуин on 22.04.2024.
//

import UIKit


protocol DetailViewProtocol: AnyObject {
    func updateData(data: [MainPost])

    func updateAvatarImage(image: UIImage)

    func showErrorAler(error: String) 
}

protocol DetailPresenterProtocol: AnyObject {
    init(view: DetailViewProtocol, user: FirebaseUser, eachPosts: [MainPost], userID: String)
}

final class DetailPresenter: DetailPresenterProtocol {

    weak var view: DetailViewProtocol?
    var user: FirebaseUser
    var posts: [MainPost]
    var image: UIImage?
    let userID: String

    init(view: DetailViewProtocol, user: FirebaseUser, eachPosts: [MainPost], userID: String) {
        self.view = view
        self.user = user
        self.posts = eachPosts
        self.userID = userID
        fetchImage()
        fetchPosts()
    }

    func fetchImage()  {
        let urlLink = user.image
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
        let firestoreService = FireStoreService()
        firestoreService.getPosts(sub: userID) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let success):
                self.posts = success
                print(self.posts)
                view?.updateData(data: self.posts)
            case .failure(let failure):
                switch failure.description {
                case  "Ошибка сервера":
                    return
                case "Ошибка декодирования":
                    return
                case "Посты отсутстуют":
                    let data: [MainPost] = []
                    view?.updateData(data: data)
                default: return
                }
            }
        }
    }
}
