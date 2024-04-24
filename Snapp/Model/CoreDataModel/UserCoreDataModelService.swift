//
//  UserCoreDataModel.swift
//  Snapp
//
//  Created by Максим Жуин on 09.04.2024.
//

import UIKit
import FirebaseStorage

final class UserCoreDataModelService {

    private(set) var modelArray: [UserMainModel]?
    let coredataService = CoreDataService.shared

    init() {
        fetchFromCoreData()
    }

    private func fetchFromCoreData() {
        let request = UserMainModel.fetchRequest()
        do {
            modelArray = try coredataService.managedContext.fetch(request)
        } catch {
            modelArray = []
            print("Cannot fetch data from CoreData modelsArray = []")
        }
    }

    func saveModelToCoreData(user: FirebaseUser, id: String)  {
        guard let modelsArray = modelArray else { return }
            let newModelToSave = UserMainModel(context: coredataService.managedContext)
            newModelToSave.id = id
            newModelToSave.name = user.name
            newModelToSave.surname = user.surname
            newModelToSave.job = user.job
            newModelToSave.city = user.city
            newModelToSave.interests = user.interests
            newModelToSave.contacts = user.contacts
            coredataService.saveContext()
            fetchFromCoreData()
    }

    func savePostsToCoreData(posts: [String : [EachPost]],
                             postsArray: [PostsMainModel]?,
                             user: UserMainModel) {
        print(posts.keys)
        print(posts.values)

        guard let postsArray = postsArray else { return }
        guard let context = user.managedObjectContext else { return }

        if postsArray.isEmpty {
            guard let context = user.managedObjectContext else { return }
            let newPost = PostsMainModel(context: context)
            for (key, value) in posts {
                newPost.date = key
                saveEachPostToCoreData(posts: value, mainModel: newPost)
                user.addToPostsMainModel(newPost)
                coredataService.saveContext()
            }
        } else {
            for model in postsArray {
                for (key, value) in posts {
                    if model.date! == key {
                        saveEachPostToCoreData(posts: value, mainModel: model)
                        coredataService.saveContext()
                        fetchFromCoreData()
                    } else {
                        guard let context = user.managedObjectContext else { return }
                        let newPost = PostsMainModel(context: context)
                        saveEachPostToCoreData(posts: value, mainModel: newPost)
                        coredataService.saveContext()
                        fetchFromCoreData()
                    }
                }
            }
        }
    }

    func saveEachPostToCoreData(posts: [EachPost], mainModel: PostsMainModel) {

        let networkService = NetworkService()

        guard let context = mainModel.managedObjectContext else { return }
        let eachPost = EachPostModel(context: context)

        for post in posts {
            networkService.fetchImage(string: post.image) { [weak self] result in
                guard let self else { return }
                switch result {
                case .success(let success):
                    eachPost.text = post.text
                    eachPost.image = success
                    eachPost.likes = Int64(post.likes)
                    eachPost.views = Int64(post.views)
                    eachPost.postMainModel = mainModel
                    mainModel.addToPosts(eachPost)
                    coredataService.saveContext()
                case .failure(let failure):
                    print(failure.localizedDescription)
                }
            }
        }
        fetchFromCoreData()
    }

    func saveSubscriber(id: String, mainModel: UserMainModel) {
        guard let context = mainModel.managedObjectContext else { return }
        let subscriber = Subscribers(context: context)
        let subscribersModelService = SubscribersCoreDataModelService(mainModel: mainModel)
        let firestoreService = FireStoreService()
        guard let subscribersArray = subscribersModelService.modelArray else { return }

        firestoreService.getUser(id: id) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let firUser):
                if subscribersArray.isEmpty {
                    subscriber.url = id
                    subscriber.job = firUser.job
                    subscriber.name = firUser.name
                    subscriber.surname = firUser.surname
                    mainModel.addToSubscribers(subscriber)
                    coredataService.saveContext()
                    fetchFromCoreData()
                } else {
                    if !subscribersArray.contains(where: { $0.url! == id }) {
                        subscriber.url = id
                        mainModel.addToSubscribers(subscriber)
                        coredataService.saveContext()
                        fetchFromCoreData()
                    }
                }
            case .failure(let failure):
                print(failure.localizedDescription)
            }
        }
    }

    func saveMainSubscriberPost(model: Subscribers, posts: [String: [String: EachPost]]) {
        guard let context = model.managedObjectContext else { return }
        let mainSubscriberPost = SubscriberPostMain(context: context)
        let mainSubscriberPostService = MainSubscriberPostService(mainModel: model)

        guard let mainSubScribersPostArray = mainSubscriberPostService.modelArray else { return }

        for (key, value) in posts {
            if let subscriberPostModel = mainSubScribersPostArray.first(where: { $0.date! == key }) {
                saveSubscriberPost(model: subscriberPostModel, posts: value)
                coredataService.saveContext()
                fetchFromCoreData()
            }
            mainSubscriberPost.date = key
            saveSubscriberPost(model: mainSubscriberPost, posts: value)
            coredataService.saveContext()
            fetchFromCoreData()
        }
    }

    func saveSubscriberPost(model: SubscriberPostMain, posts: [String: EachPost]) {

        print("\(model.date)")
        print(posts.keys, posts.values)

        guard let context = model.managedObjectContext else { return }

        let subcribersPost = SubscribersPosts(context: context)

        let networkService = NetworkService()


        for (key, value) in posts {
            networkService.fetchImage(string: value.image) { [weak self] result in
                guard let self else { return }
                switch result {
                case .success(let success):
                    subcribersPost.identifier = key
                    subcribersPost.image = success
                    subcribersPost.text = value.text
                    subcribersPost.likes = Int64(value.likes)
                    subcribersPost.views = Int64(value.views)
                    subcribersPost.mainPostModel = model
                    print(subcribersPost.text, subcribersPost.image)
                    model.addToSubscriberPosts(subcribersPost)
                    coredataService.saveContext()
                case .failure(let failure):
                    print(failure.localizedDescription)
                }
            }
        }
        fetchFromCoreData()
        print("Array: \(model.subscriberPosts?.count)")
    }

    func saveSubscriberStorie(sub: Subscribers, user: FirebaseUser) {
        let networkService = NetworkService()
        guard let context = sub.managedObjectContext else { return }
        let subscriberStory = SubStory(context: context)
        for storie in user.stories {
            networkService.fetchImage(string: storie) { [weak self] result in
                guard let self else { return }
                switch result {
                case .success(let success):
                    subscriberStory.image = success
                    sub.addToStories(subscriberStory)
                    coredataService.saveContext()
                case .failure(let failure):
                    print(failure.localizedDescription)
                }
            }
        }
        fetchFromCoreData()
    }

    func saveUserStory(data: Data, user: UserMainModel) {
        guard let context = user.managedObjectContext else { return }
        let userStory = UserStory(context: context)
        userStory.image = data
        user.addToStories(userStory)
        coredataService.saveContext()
        fetchFromCoreData()
    }
}


