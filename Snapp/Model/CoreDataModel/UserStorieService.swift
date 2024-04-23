//
//  UserStorieService.swift
//  Snapp
//
//  Created by Максим Жуин on 18.04.2024.
//

import Foundation

final class UserStorieService {

    private(set) var modelArray: [UserStory]?
    private let mainModel: UserMainModel
    let coredataService = CoreDataService.shared

    init(mainModel: UserMainModel) {
        self.mainModel = mainModel
        fetchData()
    }

    private func fetchData() {
        guard let array = mainModel.stories?.sortedArray(using: [NSSortDescriptor(key: "id", ascending: true)]) as? [UserStory] else {
            print("Cannot get array!")
            return self.modelArray = []
        }
        modelArray = array
    }

    func delete(item: UserStory) {
        mainModel.managedObjectContext?.delete(item)
        coredataService.saveContext()
        fetchData()
    }
}
