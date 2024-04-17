//
//  FeedPresenter.swift
//  Snapp
//
//  Created by Максим Жуин on 06.04.2024.
//

import UIKit

protocol FeedViewProtocol: AnyObject {
    func showEmptyScreen()
}

protocol FeedPresenterProtocol: AnyObject {
    init(view: FeedViewProtocol, user: UserMainModel)
}


final class FeedPresenter: FeedPresenterProtocol {

    weak var view: FeedViewProtocol?
    let user: UserMainModel
    var posts: [SubscribersPosts]?

    init(view: FeedViewProtocol, user: UserMainModel) {
        self.view = view
        self.user = user
    }

    func saveSubscriber(id: String, completion: @escaping (Result<UserMainModel, Error>) -> Void) {
        let firestoreService = FireStoreService()

        firestoreService.saveSubscriber(mainUser: user.id!, id: id)

        let subscribersModelService = SubscribersCoreDataModelService(mainModel: user)

        let userModelService = UserCoreDataModelService()

        guard let subscribersArray = subscribersModelService.modelArray else { return }

        for subscriber in subscribersArray {
            let mainSubPostService = MainSubscriberPostService(mainModel: subscriber)
            guard let modelsArray = mainSubPostService.modelArray else { return }
            for post in modelsArray {
                let eachSubPost = EachSubscriberPostService(mainModel: post)
                guard let eachSubPostArray = eachSubPost.modelArray else { return }
                for eachPost in eachSubPostArray {
                    firestoreService.getPosts(sub: id, time: eachPost.identifier!) { [weak self] result in
                        guard let self else { return }
                        switch result {
                        case .success(let posts):
                            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                                userModelService.saveSubscriber(id: id, mainModel: self.user, posts: posts)
                                completion(.success(self.user))
                            }
                        case .failure(let failure):
                            print("failure")
                            completion(.failure(failure))
                        }
                    }
                }
            }
        }
    }

    func fetchPosts() {
        let firestoreService = FireStoreService()
        let subscribersModelService = SubscribersCoreDataModelService(mainModel: user)
        let mainUserModelService = UserCoreDataModelService()

        if checkCoreData() {
            guard let subscribersArray = subscribersModelService.modelArray else { return }
            for subscriber in subscribersArray {
                let mainSubService = MainSubscriberPostService(mainModel: subscriber)
                guard let mainSubArray = mainSubService.modelArray else { return }
                for mainSub in mainSubArray {
                    let eachSubPost = EachSubscriberPostService(mainModel: mainSub)
                    guard let eachSubArray = eachSubPost.modelArray else { return }
                    for eachPost in eachSubArray {
                        firestoreService.getPosts(sub: subscriber.url!, time: eachPost.identifier!) { [weak self] result in
                            guard let self else { return }
                            switch result {
                            case .success(let fireStorePosts):
                                mainUserModelService.saveMainSubscriberPost(model: subscriber, posts: fireStorePosts)
                            case .failure(let failure):
                                print(failure.localizedDescription)
                            }
                        }
                    }
                }
            }
        }
    }

    func checkCoreData() -> Bool {

        let subscribersModelService = SubscribersCoreDataModelService(mainModel: user)

        guard let subscribersArray = subscribersModelService.modelArray else { return false }

        if subscribersArray.isEmpty {
            return false
        }
        return true
    }
}
