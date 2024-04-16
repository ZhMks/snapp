//
//  SubscribersCoreDataModelService.swift
//  Snapp
//
//  Created by Максим Жуин on 16.04.2024.
//

import Foundation


final class SubscribersCoreDataModelService {

    private(set) var modelArray: [Subscribers]?
    private let mainModel: UserMainModel
    let coredataService = CoreDataService.shared

    init(mainModel: UserMainModel) {
        self.mainModel = mainModel
        fetchData()
    }

    private func fetchData() {
        guard let array = mainModel.subscribers?.sortedArray(using: [NSSortDescriptor(key: "url", ascending: true)]) as? [Subscribers] else {
            print("Cannot get array!")
            return self.modelArray = []
        }
        modelArray = array
    }

    func delete(item: PostsMainModel) {
        mainModel.managedObjectContext?.delete(item)
        coredataService.saveContext()
        fetchData()
    }
}
