//
//  EachSubscriberPost.swift
//  Snapp
//
//  Created by Максим Жуин on 16.04.2024.
//

import Foundation


final class EachSubscriberPostService {

    private(set) var modelArray: [SubscribersPosts]?
    private let mainModel: SubscriberPostMain
    let coredataService = CoreDataService.shared

    init(mainModel: SubscriberPostMain) {
        self.mainModel = mainModel
        fetchData()
    }

    private func fetchData() {
        guard let array = mainModel.subscriberPosts?.sortedArray(using: [NSSortDescriptor(key: "id", ascending: true)]) as? [SubscribersPosts] else {
            print("Cannot get array!")
            return self.modelArray = []
        }
        modelArray = array
    }

    func delete(item: SubscribersPosts) {
        mainModel.managedObjectContext?.delete(item)
        coredataService.saveContext()
        fetchData()
    }
}
