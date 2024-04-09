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

    func saveModelToCoreData(user: FirebaseUser) {}
}


