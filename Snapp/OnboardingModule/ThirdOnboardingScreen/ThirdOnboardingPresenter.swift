//
//  ThirdOnboardingPresenter.swift
//  Snapp
//
//  Created by Максим Жуин on 02.04.2024.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseStorage
import FirebaseAuth
import FirebaseDatabase
import CoreData


protocol ThirdOnboardingViewProtocol: AnyObject {
    func showCreateUserScreen()
    func showUserExistAlert(id: String)
    func showErrorAlert(error: String)
}

protocol ThirdOnboardingPresenterProtocol: AnyObject {
    var authService: FireBaseAuthProtocol? { get set }
    var firestoreService: FireStoreServiceProtocol? { get set }
    init (view: ThirdOnboardingViewProtocol, authService: FireBaseAuthProtocol, firestoreService: FireStoreServiceProtocol)
    func checkCode(code: String)
}

final class ThirdOnboardingPresenter: ThirdOnboardingPresenterProtocol {

    weak var view: ThirdOnboardingViewProtocol?
    var authService: FireBaseAuthProtocol?
    var firestoreService: FireStoreServiceProtocol?
    let firestore = Firestore.firestore()

    init(view: any ThirdOnboardingViewProtocol, authService: FireBaseAuthProtocol, firestoreService: FireStoreServiceProtocol) {
        self.view = view
        self.authService = authService
        self.firestoreService = firestoreService
    }

    func checkCode(code: String) {
        authService?.verifyCode(code: code) { [weak self] result in
            switch result {
            case .success(let success):
                self?.firestoreService?.getUser(id: success.uid) { result in
                    switch result {
                    case .success(let user):
                        self?.view?.showUserExistAlert(id: user.documentID!)
                    case .failure(_):
                        self?.view?.showCreateUserScreen()
                    }
                }
            case .failure(let failure):
                self?.view?.showErrorAlert(error: failure.description)
            }
        }
    }
}
