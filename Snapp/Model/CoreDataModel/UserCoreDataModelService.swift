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

    func saveModelToCoreData(user: FirebaseUser, posts: [String: [String: EachPost]], completion: @escaping (Result<UserMainModel, Error>) -> Void) {
        guard let modelArray = modelArray else { return }
        let newModelToSave = UserMainModel(context: coredataService.managedContext)
        newModelToSave.id = user.id
        savePostsToCoreData(posts: posts, mainModel: newModelToSave)
        coredataService.saveContext()
        fetchFromCoreData()
        completion(.success(newModelToSave))
    }

    func savePostsToCoreData(posts: [String : [String : EachPost]], mainModel: UserMainModel) {
        
        guard let context = mainModel.managedObjectContext else { return }
        
        let newPosts = PostsMainModel(context: context)

        for (key, value) in posts {
            saveEachPostToCoreData(posts: value, mainModel: newPosts)
            newPosts.date = key
        }

        coredataService.saveContext()
    }

    func saveEachPostToCoreData(posts: [String : EachPost], mainModel: PostsMainModel) {
        guard let context = mainModel.managedObjectContext else { return }
        let eachPost = EachPostModel(context: context)

        
        for (key, value) in posts {
            eachPost.identifier = key
            if key == "text" {
                eachPost.text = value.text
                print(eachPost.text)
            }

            if key == "image" {
                eachPost.image = value.image
                print(eachPost.image)
            }

            if key == "likes" {
                eachPost.likes = Int16(value.likes)
                print(eachPost.likes)
            }

            if key == "views" {
                eachPost.views = Int16(value.views)
                print(eachPost.views)
            }
        }
        print(eachPost.likes)
        print(eachPost.views)
        print(eachPost.text)
        coredataService.saveContext()
    }
}


