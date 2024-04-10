//
//  EachPostCoreDataModel.swift
//  Snapp
//
//  Created by Максим Жуин on 09.04.2024.
//

import Foundation


final class EachPostCoreDataModelService {

    private(set) var modelArray: [EachPostModel]?
    private let mainModel: PostsMainModel
    let coredataService = CoreDataService.shared
    
    init(mainModel: PostsMainModel) {
        self.mainModel = mainModel
    }

    private func fetchData() {
        guard let array = mainModel.posts?.sortedArray(using: [NSSortDescriptor(key: "date", ascending: true)]) as? [EachPostModel] else {
            return self.modelArray = []
        }
        print(array)
        modelArray = array
    }

    func delete(item: PostsMainModel) {
        mainModel.managedObjectContext?.delete(item)
        coredataService.saveContext()
        fetchData()
    }
}
