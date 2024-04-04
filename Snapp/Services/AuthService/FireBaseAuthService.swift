//
//  FireBaseAuthService.swift
//  Snapp
//
//  Created by Максим Жуин on 03.04.2024.
//

import Foundation
import FirebaseAuth

protocol FireBaseAuthProtocol {
    var verificationID: String? { get set }
    func signUpUser(phone: String, completion: @escaping (Bool) -> Void)
    func verifyCode(code: String, completion: @escaping (Result<User, Error>) -> Void)
}

final class FireBaseAuthService: FireBaseAuthProtocol {

    internal var verificationID: String?

    func signUpUser(phone: String, completion: @escaping (Bool) -> Void) {
        PhoneAuthProvider.provider().verifyPhoneNumber(phone, uiDelegate: nil) { [weak self] verificationID, error in
            if error != nil {
                completion(false)
            }

            if let verificationID = verificationID {
                self?.verificationID = verificationID
                completion(true)
            }
        }
    }

    func verifyCode(code: String, completion: @escaping (Result<User, Error>) -> Void) {
        guard let verificationID = verificationID else {
            return
        }

        let credential = PhoneAuthProvider.provider().credential(withVerificationID: verificationID , verificationCode: code)

        Auth.auth().signIn(with: credential) { result, error in
            if let error = error {
                completion(.failure(error))
            }
            if let result = result {
                completion(.success(result.user))
            }
        }
    }
}
