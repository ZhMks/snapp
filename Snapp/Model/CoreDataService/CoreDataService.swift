//
//  CoreDataService.swift
//  Snapp
//
//  Created by Максим Жуин on 09.04.2024.
//

import UIKit
import CoreData


final class CoreDataService {

    static let shared = CoreDataService()

    private init() {}

    private let persistantContainer: NSPersistentContainer = {
            let container = NSPersistentContainer(name: "UserModel")
            container.loadPersistentStores { storeDescription, error in
                if let error = error {
                    print(error.localizedDescription)
                }
            }
            return container
        }()

    lazy var managedContext: NSManagedObjectContext = {
            return persistantContainer.viewContext
        }()

    func saveContext() {
            if managedContext.hasChanges {
                do {
                    try managedContext.save()
                } catch {
                    print("Error in CoreDataSave: \(error.localizedDescription)")
                }
            }
        }

        func deleteObject(object: PostsMainModel) {
            managedContext.delete(object)
        }

}
