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
        print(modelArray?.count)
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

    func saveModelToCoreData(user: FirebaseUser, id: String, posts: [String: [String: EachPost]], completion: @escaping (Result<UserMainModel, Error>) -> Void) {
        guard let modelsArray = modelArray else { return }
        if modelsArray.isEmpty {
            let newModelToSave = UserMainModel(context: coredataService.managedContext)
            newModelToSave.id = id
            newModelToSave.name = user.name
            newModelToSave.surname = user.surname
            newModelToSave.job = user.job
            newModelToSave.city = user.city
            newModelToSave.interests = user.interests
            newModelToSave.contacts = user.contacts
            savePostsToCoreData(posts: posts, mainModel: newModelToSave)
            coredataService.saveContext()
            fetchFromCoreData()
            completion(.success(newModelToSave))
        } else {
            completion(.success(modelsArray.first!))
        }
    }

    func savePostsToCoreData(posts: [String : [String : EachPost]], mainModel: UserMainModel) {
        
        guard let context = mainModel.managedObjectContext else { return }
        
        let newPosts = PostsMainModel(context: context)

        for (key, value) in posts {
            saveEachPostToCoreData(posts: value, mainModel: newPosts)
            newPosts.date = key
        }
        newPosts.mainUser = mainModel
        coredataService.saveContext()
        fetchFromCoreData()

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
            coredataService.saveContext()
        }
        fetchFromCoreData()
    }
}


