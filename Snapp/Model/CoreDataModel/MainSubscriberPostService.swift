//
//  MainSubscriberModel.swift
//  Snapp
//
//  Created by Максим Жуин on 16.04.2024.
//

import Foundation


final class MainSubscriberPostService {

    private(set) var modelArray: [SubscriberPostMain]?
    private let mainModel: Subscribers
    let coredataService = CoreDataService.shared

    init(mainModel: Subscribers) {
        self.mainModel = mainModel
        fetchData()
    }

    private func fetchData() {
        guard let array = mainModel.subscriberPostMain?.sortedArray(using: [NSSortDescriptor(key: "date", ascending: true)]) as? [SubscriberPostMain] else {
            print("Cannot get array")
            return self.modelArray = []
        }
        self.modelArray = array
    }

    func delete(item: PostsMainModel) {
            mainModel.managedObjectContext?.delete(item)
            coredataService.saveContext()
            fetchData()
        }
}
