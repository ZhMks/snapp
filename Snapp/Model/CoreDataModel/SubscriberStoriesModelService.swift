//
//  SubscriberStoriesModelService.swift
//  Snapp
//
//  Created by Максим Жуин on 18.04.2024.
//

import Foundation


final class SubscriberStoriesModelService {

    private(set) var modelArray: [SubStory]?
    private let mainModel: Subscribers
    let coredataService = CoreDataService.shared

    init(mainModel: Subscribers) {
        self.mainModel = mainModel
        fetchData()
    }

    private func fetchData() {
        guard let array = mainModel.stories?.sortedArray(using: [NSSortDescriptor(key: "id", ascending: true)]) as? [SubStory] else {
            print("Cannot get array!")
            return self.modelArray = []
        }
        modelArray = array
    }

    func delete(item: SubStory) {
        mainModel.managedObjectContext?.delete(item)
        coredataService.saveContext()
        fetchData()
    }
}
