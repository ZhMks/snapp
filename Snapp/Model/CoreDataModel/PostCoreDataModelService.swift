//
//  PostCoreDataModel.swift
//  Snapp
//
//  Created by Максим Жуин on 09.04.2024.
//

import UIKit


final class PostsCoreDataModelService {

    private(set) var modelArray: [PostsMainModel]?
    private let mainModel: UserMainModel
    let coredataService = CoreDataService.shared

    init(mainModel: UserMainModel) {
        self.mainModel = mainModel
    }

    private func fetchData() {
        guard let array = mainModel.postsMainModel?.sortedArray(using: [NSSortDescriptor(key: "date", ascending: true)]) as? [PostsMainModel] else {
            return self.modelArray = []
        }
        print(array)
        self.modelArray = array
    }

    func delete(item: PostsMainModel) {
            mainModel.managedObjectContext?.delete(item)
            coredataService.saveContext()
            fetchData()
        }
}
