//
//  UserCoreDataModel.swift
//  Snapp
//
//  Created by Максим Жуин on 09.04.2024.
//

import UIKit

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

    func savePostsToCoreData(posts: [String : [String : EachPost]],
                             postsArray: [PostsMainModel]?,
                             user: UserMainModel) {

        guard let postsArray = postsArray else { return }

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
            postsArray.forEach { model in
                for (key, value) in posts {
                    if model.date! == key {
                        saveEachPostToCoreData(posts: value, mainModel: model)
                        coredataService.saveContext()
                    } else {
                        guard let context = user.managedObjectContext else { return }
                        let newPost = PostsMainModel(context: context)
                        newPost.date = key
                        user.addToPostsMainModel(newPost)
                        saveEachPostToCoreData(posts: value, mainModel: newPost)
                        coredataService.saveContext()
                    }
                }
            }
        }
    }

    func saveEachPostToCoreData(posts: [String : EachPost], mainModel: PostsMainModel) {

        guard let context = mainModel.managedObjectContext else { return }
        for (key, value) in posts {
            let eachPost = EachPostModel(context: context)
            eachPost.identifier = key
            eachPost.text = value.text
            eachPost.image = value.image
            eachPost.likes = Int64(value.likes)
            eachPost.views = Int64(value.views)
            eachPost.postMainModel = mainModel
            mainModel.addToPosts(eachPost)
            coredataService.saveContext()
        }
        fetchFromCoreData()
    }

    func saveSubscriber(id: String, mainModel: UserMainModel, posts: [String : [String : EachPost]]) {
        guard let context = mainModel.managedObjectContext else { return }
        let subscribers = Subscribers(context: context)
        subscribers.url = id
        saveMainSubscriberPost(model: subscribers, posts: posts)
        mainModel.addToSubscribers(subscribers)
        coredataService.saveContext()
        fetchFromCoreData()
    }

    func saveMainSubscriberPost(model: Subscribers, posts: [String: [String: EachPost]]) {
        guard let context = model.managedObjectContext else { return }
        let mainSubscriberPost = SubscriberPostMain(context: context)
        for (key, value) in posts {
            mainSubscriberPost.date = key
            model.addToSubscriberPostMain(mainSubscriberPost)
            saveSubscriberPost(model: mainSubscriberPost, posts: value)
            coredataService.saveContext()
        }
        fetchFromCoreData()
    }

    func saveSubscriberPost(model: SubscriberPostMain, posts: [String: EachPost]) {

        print("\(model.date)")
        print(posts.keys, posts.values)

        guard let context = model.managedObjectContext else { return }

        let subcribersPost = SubscribersPosts(context: context)


        for (key, value) in posts {
            subcribersPost.identifier = key
            subcribersPost.image = value.image
            subcribersPost.text = value.text
            subcribersPost.likes = Int64(value.likes)
            subcribersPost.views = Int64(value.views)
            subcribersPost.mainPostModel = model
            print(subcribersPost.text, subcribersPost.image)
            model.addToSubscriberPosts(subcribersPost)
            coredataService.saveContext()
        }
        fetchFromCoreData()
        print("Array: \(model.subscriberPosts?.count)")
    }
}


