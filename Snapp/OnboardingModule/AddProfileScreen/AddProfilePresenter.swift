//
//  AddProfilePresenter.swift
//  Snapp
//
//  Created by Максим Жуин on 11.04.2024.
//

import UIKit


protocol AddProfileViewProtocol: AnyObject {

}

protocol AddProfilePresenterProtocol: AnyObject {
    init(view: AddProfileViewProtocol, firebaseUser: FirebaseUser, firestoreService: FireStoreService, userCoreDataService: UserCoreDataModelService)
    func createUser(name: String, surname: String, job: String, city: String, interests: String, contacts: String, image: UIImage)
}



final class AddProfilePresenter: AddProfilePresenterProtocol {

    weak var view: AddProfileViewProtocol?
    var firebaseUser: FirebaseUser
    let firestoreService: FireStoreService
    let userCoreDataService: UserCoreDataModelService

    init(view: AddProfileViewProtocol, firebaseUser: FirebaseUser, firestoreService: FireStoreService, userCoreDataService: UserCoreDataModelService) {
        self.view = view
        self.firebaseUser = firebaseUser
        self.firestoreService = firestoreService
        self.userCoreDataService = userCoreDataService
    }
    func createUser(name: String, surname: String, job: String, city: String, interests: String, contacts: String, image: UIImage) {

        firebaseUser.name = name
        firebaseUser.surname = surname
        firebaseUser.job = job
        firebaseUser.city = city
        firebaseUser.interests = interests
        firebaseUser.contacts = contacts

        firestoreService.saveImageIntoStorage(photo: image, for: firebaseUser.id!) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let success):
                firebaseUser.image = success.absoluteString
                firestoreService.createUser(user: firebaseUser)
            case .failure(let failure):
                print(failure.localizedDescription)
            }
        }
    }
}
