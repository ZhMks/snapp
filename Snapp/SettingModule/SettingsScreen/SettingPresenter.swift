//
//  SettingPresenter.swift
//  Snapp
//
//  Created by Максим Жуин on 08.04.2024.
//

import UIKit


protocol SettingsViewProtocol: AnyObject {

}

protocol SettingsPresenterProtocol: AnyObject {
    var firestoreService: FireStoreServiceProtocol? { get set }
    init(view: SettingsViewProtocol?, user: FirebaseUser, firestoreService: FireStoreServiceProtocol)
}

final class SettingPresenter: SettingsPresenterProtocol {
   weak var view: SettingsViewProtocol?
    var user: FirebaseUser
    var firestoreService: FireStoreServiceProtocol?

    init(view: SettingsViewProtocol?, user: FirebaseUser, firestoreService: FireStoreServiceProtocol) {
        self.view = view
        self.user = user
        self.firestoreService = firestoreService
    }
}
