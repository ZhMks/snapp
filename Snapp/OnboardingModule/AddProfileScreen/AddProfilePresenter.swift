//
//  AddProfilePresenter.swift
//  Snapp
//
//  Created by Максим Жуин on 11.04.2024.
//

import UIKit
import FirebaseAuth

protocol AddProfileViewProtocol: AnyObject {

}

protocol AddProfilePresenterProtocol: AnyObject {
    init(view: AddProfileViewProtocol, firebaseUser: User, firestoreService: FireStoreService, userCoreDataService: UserCoreDataModelService)
    func createUser(name: String, surname: String, job: String, city: String, interests: String, contacts: String, image: UIImage, completion: @escaping (Result <FirebaseUser, Error>) -> Void)
}



final class AddProfilePresenter: AddProfilePresenterProtocol {

    weak var view: AddProfileViewProtocol?
    var fireAuthUser: User
    let firestoreService: FireStoreService
    let userCoreDataService: UserCoreDataModelService

    init(view: AddProfileViewProtocol, firebaseUser: User, firestoreService: FireStoreService, userCoreDataService: UserCoreDataModelService) {
        self.view = view
        self.fireAuthUser = firebaseUser
        self.firestoreService = firestoreService
        self.userCoreDataService = userCoreDataService
    }

    func createUser(name: String, surname: String, job: String, city: String, interests: String, contacts: String, image: UIImage, completion: @escaping (Result <FirebaseUser, Error>) -> Void) {

        var firebaseUser = FirebaseUser(name: "", surname: "", job: "", subscribers: [], subscribtions: [], stories: [], interests: "", contacts: "", city: "", image: "")

        firebaseUser.name = name
        firebaseUser.surname = surname
        firebaseUser.job = job
        firebaseUser.city = city
        firebaseUser.interests = interests
        firebaseUser.contacts = contacts
        firebaseUser.stories = []
        firebaseUser.subscribers = []
        firebaseUser.subscribtions = []

        firestoreService.saveImageIntoStorage(photo: image, for: fireAuthUser.uid) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let success):
                firebaseUser.image = success.absoluteString
                firestoreService.createUser(user: firebaseUser, id: fireAuthUser.uid)
                completion(.success(firebaseUser))
            case .failure(let failure):
                print(failure.localizedDescription)
            }
        }
    }
}
