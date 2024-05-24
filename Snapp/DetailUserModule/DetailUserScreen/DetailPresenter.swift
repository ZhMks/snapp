//
//  DetailPresenter.swift
//  Snapp
//
//  Created by Максим Жуин on 22.04.2024.
//

import UIKit
import FirebaseAuth

protocol DetailViewProtocol: AnyObject {
    func updateData(data: [EachPost])

    func updateAvatarImage(image: UIImage)

    func showErrorAler(error: String) 
}

protocol DetailPresenterProtocol: AnyObject {
    init(view: DetailViewProtocol, user: FirebaseUser, userID: String, firestoreService: FireStoreServiceProtocol)
}

final class DetailPresenter: DetailPresenterProtocol {

    weak var view: DetailViewProtocol?
    let firestoreService: FireStoreServiceProtocol
    var user: FirebaseUser
    var posts: [EachPost] = []
    var image: UIImage?
    let userID: String

    init(view: DetailViewProtocol, user: FirebaseUser, userID: String, firestoreService: FireStoreServiceProtocol) {
        self.view = view
        self.user = user
        self.userID = userID
        self.firestoreService = firestoreService
        fetchImage()
    }

    func fetchImage()  {
        guard let urlLink = user.image else { return }
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
                posts = success
                print(posts)
                view?.updateData(data: posts)
            case .failure(let failure):
                switch failure.description {
                case  "Ошибка сервера":
                    return
                case "Ошибка декодирования":
                    return
                case "Посты отсутстуют":
                    let data: [EachPost] = []
                    view?.updateData(data: data)
                default: return
                }
            }
        }
    }

    func addSubscriber() {
        print(userID)
        guard  let currentUser = Auth.auth().currentUser?.uid else { return }
        print(currentUser)
        firestoreService.saveSubscriber(mainUser: currentUser, id: userID)
    }
}
