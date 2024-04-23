//
//  FeedPresenter.swift
//  Snapp
//
//  Created by Максим Жуин on 06.04.2024.
//

import UIKit
import FirebaseStorage

protocol FeedViewProtocol: AnyObject {
    func showEmptyScreen()
}

protocol FeedPresenterProtocol: AnyObject {
    init(view: FeedViewProtocol, user: UserMainModel)
}


final class FeedPresenter: FeedPresenterProtocol {

    weak var view: FeedViewProtocol?
    let user: UserMainModel
    var posts: [SubscriberPostMain]?
    var stories: [UIImage]?
    var userStorie: UIImage?

    init(view: FeedViewProtocol, user: UserMainModel) {
        self.view = view
        self.user = user
    }

    func saveSubscriber(id: String, completion: @escaping (Result<UserMainModel, Error>) -> Void) {

        let firestoreService = FireStoreService()

        firestoreService.saveSubscriber(mainUser: user.id!, id: id)

        let subscribersModelService = SubscribersCoreDataModelService(mainModel: user)

        let userModelService = UserCoreDataModelService()

        userModelService.saveSubscriber(id: id, mainModel: user)

    }

    func fetchSubscribersPosts() {
        let subscribersModelService = SubscribersCoreDataModelService(mainModel: user)
        guard let subscribersArray = subscribersModelService.modelArray else { return }

        if !subscribersArray.isEmpty {
            for subscriber in subscribersArray {
                let subscribersPostService = MainSubscriberPostService(mainModel: subscriber)
                guard let subscriberPostsArray = subscribersPostService.modelArray else { return }
                self.posts = subscriberPostsArray
            }
        }
    }
}
