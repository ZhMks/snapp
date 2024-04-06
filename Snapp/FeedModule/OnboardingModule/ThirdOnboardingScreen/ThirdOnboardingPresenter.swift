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


protocol ThirdOnboardingViewProtocol: AnyObject {
    func showAlert(error: String)
}

protocol ThirdOnboardingPresenterProtocol: AnyObject {
    var authService: FireBaseAuthProtocol? { get set }
    init (view: ThirdOnboardingViewProtocol, authService: FireBaseAuthProtocol)
    func checkCode(code: String, completion: @escaping (Result<FirebaseUser,Error>) -> Void)
}

final class ThirdOnboardingPresenter: ThirdOnboardingPresenterProtocol {

    weak var view: ThirdOnboardingViewProtocol?
    var authService: FireBaseAuthProtocol?
    let firestore = Firestore.firestore()

    init(view: any ThirdOnboardingViewProtocol, authService: FireBaseAuthProtocol) {
        self.view = view
        self.authService = authService
    }

    func checkCode(code: String, completion: @escaping (Result<FirebaseUser,Error>) -> Void) {
        authService?.verifyCode(code: code) { [weak self] result in
            switch result {
            case .success(let success):
                print(success.uid)
                self?.firestore.collection("Users").document("\(success.uid)").setData(["name": "jack", "surname" : "jaxon", "job" : "worker",
                                                                                        "stories": ["firstStorie": "URL1", "SecondStorie": "URL2"],
                                                                                        "subscribers" : ["firstSub": "URL1", "secondSub": "URL2"],
                                                                                        "subscriptions" : ["firstSub": "URL1", "secondSub": "URL2"]])
                let firebaseUser = FirebaseUser(user: success, name: "NewName", surname: "NewSurname", job: "NewJob")
                completion(.success(firebaseUser))
            case .failure(let failure):
                completion(.failure(failure))
                self?.view?.showAlert(error: failure.description)
            }
        }
    }
}
