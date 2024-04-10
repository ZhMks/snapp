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
    func showAlert(error: String)
}

protocol ThirdOnboardingPresenterProtocol: AnyObject {
    var authService: FireBaseAuthProtocol? { get set }
    var firestoreService: FireStoreServiceProtocol? { get set }
    init (view: ThirdOnboardingViewProtocol, authService: FireBaseAuthProtocol, firestoreService: FireStoreServiceProtocol, userModelService: UserCoreDataModelService)
    func checkCode(code: String, completion: @escaping (Result<UserMainModel,Error>) -> Void)
}

final class ThirdOnboardingPresenter: ThirdOnboardingPresenterProtocol {

    weak var view: ThirdOnboardingViewProtocol?
    var authService: FireBaseAuthProtocol?
    var firestoreService: FireStoreServiceProtocol?
    let firestore = Firestore.firestore()
    let userModelService: UserCoreDataModelService

    init(view: any ThirdOnboardingViewProtocol, authService: FireBaseAuthProtocol, firestoreService: FireStoreServiceProtocol, userModelService: UserCoreDataModelService ) {
        self.view = view
        self.authService = authService
        self.firestoreService = firestoreService
        self.userModelService = userModelService
    }

    func checkCode(code: String, completion: @escaping (Result<UserMainModel,Error>) -> Void) {
        authService?.verifyCode(code: code) { [weak self] result in
            switch result {
            case .success(let success):
                self?.firestoreService?.getUser(id: success.uid) { result in
                    switch result {
                    case .success(let user):
                        self?.firestoreService?.getPosts(id: user.id!, completion: { result in
                                switch result {
                                case .success(let success):
                                        self?.userModelService.saveModelToCoreData(user: user, posts: success) { result in
                                            switch result {
                                            case .success(let success):
                                                completion(.success(success))
                                            case .failure(let failure):
                                                print("Error in saving Model to Coredata: \(failure.localizedDescription)")
                                            }
                                        }
                                case .failure(let failure):
                                    print("Error in getting POST: \(failure.localizedDescription)")
                                }
                            })
                    case .failure(let failure):
                        self?.view?.showAlert(error: failure.localizedDescription)
                    }
                }
            case .failure(let failure):
                completion(.failure(failure))
                self?.view?.showAlert(error: failure.description)
            }
        }
    }
}
