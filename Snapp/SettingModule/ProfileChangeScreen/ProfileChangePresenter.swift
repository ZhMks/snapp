//
//  ProfileChangePresenter.swift
//  Snapp
//
//  Created by Максим Жуин on 08.04.2024.
//

import UIKit

protocol ProfileChangeViewProtocol {}

protocol ProfileChangePresenterProtocol {
    var firestoreService: FireStoreServiceProtocol? { get set }
    init(view: ProfileChangeViewProtocol?, user: UserMainModel, firestoreService: FireStoreServiceProtocol)
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


    var view: ProfileChangeViewProtocol?
    var user: UserMainModel
    var firestoreService: FireStoreServiceProtocol?

    init(view: ProfileChangeViewProtocol?, user: UserMainModel, firestoreService: FireStoreServiceProtocol) {
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
