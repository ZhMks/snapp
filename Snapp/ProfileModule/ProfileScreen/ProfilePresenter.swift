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
    init(view: ProfileViewProtocol, mainUser: UserMainModel, firestoreService: FireStoreServiceProtocol)
}

final class ProfilePresenter: ProfilePresenterProtocol {

   weak var view: ProfileViewProtocol?
    var mainUser: UserMainModel
    var firestoreService: FireStoreServiceProtocol

    init(view: ProfileViewProtocol, mainUser: UserMainModel, firestoreService: FireStoreServiceProtocol) {
        self.view = view
        self.mainUser = mainUser
        self.firestoreService = firestoreService
    }

    func createPost(text: String, image: UIImage, completion: @escaping (Result<PostsMainModel, Error>) -> Void) {
        let date = Date()
        let time = date.timeIntervalSinceNow
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        let stringFromDate = formatter.string(from: date)
        let timeString = String(time)
        firestoreService.createPost(date: stringFromDate, time: timeString, text: text, image: image, for: mainUser) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let firestorePost):
              let userModelService = UserCoreDataModelService()
              let postsModelService = PostsCoreDataModelService(mainModel: mainUser)
                guard let postsArray = postsModelService.modelArray else { return }
                userModelService.savePostsToCoreData(posts: [stringFromDate : [timeString : firestorePost]], mainModel: mainUser)
            case .failure(let error):
                view?.showErrorAler(error: error.localizedDescription)
            }
        }
    }
}
