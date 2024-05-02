//
//  ProfilePresenter.swift
//  Snapp
//
//  Created by Максим Жуин on 08.04.2024.
//

import UIKit

protocol ProfileViewProtocol: AnyObject {
    func showErrorAler(error: String)
}

protocol ProfilePresenterProtocol: AnyObject {
    init(view: ProfileViewProtocol, mainUser: FirebaseUser, firestoreService: FireStoreServiceProtocol)
}

final class ProfilePresenter: ProfilePresenterProtocol {

   weak var view: ProfileViewProtocol?
    var mainUser: FirebaseUser
    var firestoreService: FireStoreServiceProtocol
    var posts: [MainPost]?


    init(view: ProfileViewProtocol, mainUser: FirebaseUser, firestoreService: FireStoreServiceProtocol) {
        self.view = view
        self.mainUser = mainUser
        self.firestoreService = firestoreService
        fetchPosts()
    }

    func createPost(text: String, image: UIImage, completion: @escaping (Result<MainPost, Error>) -> Void) {
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        let stringFromDate = formatter.string(from: date)

        firestoreService.createPost(date: stringFromDate, text: text, image: image, for: mainUser) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let firestorePost):
                print()
            case .failure(let error):
                view?.showErrorAler(error: error.localizedDescription)
            }
        }
    }

    func fetchPosts() {

    }
}
