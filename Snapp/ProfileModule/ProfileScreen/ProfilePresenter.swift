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
    init(view: ProfileViewProtocol, mainUser: UserMainModel, firestoreService: FireStoreServiceProtocol, userModelService: UserCoreDataModelService)
}

final class ProfilePresenter: ProfilePresenterProtocol {

   weak var view: ProfileViewProtocol?
    var mainUser: UserMainModel
    var firestoreService: FireStoreServiceProtocol
    let userModelService: UserCoreDataModelService
    var posts: [PostsMainModel]?


    init(view: ProfileViewProtocol, mainUser: UserMainModel, firestoreService: FireStoreServiceProtocol, userModelService: UserCoreDataModelService) {
        self.view = view
        self.mainUser = mainUser
        self.firestoreService = firestoreService
        self.userModelService = userModelService
        fetchPosts()
    }

    func createPost(text: String, image: UIImage, completion: @escaping (Result<PostsMainModel, Error>) -> Void) {
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        let stringFromDate = formatter.string(from: date)

        firestoreService.createPost(date: stringFromDate, text: text, image: image, for: mainUser) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let firestorePost):
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    self.userModelService.savePostsToCoreData(posts: [stringFromDate : [firestorePost]],
                                                              postsArray: self.posts,
                                                              user: self.mainUser)
                }
            case .failure(let error):
                view?.showErrorAler(error: error.localizedDescription)
            }
        }
    }

    func fetchPosts() {
        let postsModelService = PostsCoreDataModelService(mainModel: mainUser)
        guard let postsArray = postsModelService.modelArray else { return }
        self.posts = postsArray
    }
}
