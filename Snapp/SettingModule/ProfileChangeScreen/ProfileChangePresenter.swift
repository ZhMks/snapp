//
//  ProfileChangePresenter.swift
//  Snapp
//
//  Created by Максим Жуин on 08.04.2024.
//

import UIKit

protocol ProfileChangeViewProtocol: AnyObject {}

protocol ProfileChangePresenterProtocol: AnyObject {
    init(view: ProfileChangeViewProtocol?, user: FirebaseUser, firestoreService: FireStoreServiceProtocol)
    func changeName()
    func changeSurname()
    func changeSex()
    func changeDateOfBirth()
    func changeCity()
    func changeContacts()
    func changeInterests()
    func changeEducation()
    func changeJob()
}

final class ProfileChangePresenter: ProfileChangePresenterProtocol {


   weak var view: ProfileChangeViewProtocol?
    var user: FirebaseUser
    var firestoreService: FireStoreServiceProtocol

    init(view: ProfileChangeViewProtocol?, user: FirebaseUser, firestoreService: FireStoreServiceProtocol) {
        self.view = view
        self.user = user
        self.firestoreService = firestoreService
    }

    func changeName() {

    }

    func changeSurname() {

    }

    func changeSex() {

    }

    func changeDateOfBirth() {

    }

    func changeCity() {

    }

    func changeContacts() {

    }

    func changeInterests() {

    }

    func changeEducation() {

    }

    func changeJob() {
        
    }
}
