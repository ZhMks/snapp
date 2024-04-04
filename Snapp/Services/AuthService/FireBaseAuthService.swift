//
//  FireBaseAuthService.swift
//  Snapp
//
//  Created by Максим Жуин on 03.04.2024.
//

import Foundation
import FirebaseAuth

final class FireBaseAuthService {

    private var verificationID: String?

    func signUpUser(phone: String, completion: @escaping (Bool) -> Void) {
        PhoneAuthProvider.provider().verifyPhoneNumber(phone, uiDelegate: nil) { [weak self] verificationID, error in
            if error != nil {
                completion(false)
            }

            if let verificationID = verificationID {
                self?.verificationID = verificationID
                print(verificationID)
                completion(true)
            }
        }
    }

    func verifyCode(code: String, completion: @escaping (Bool) -> Void) {
        guard let verificationID = verificationID else {
            completion(false)
            return
        }

        let credential = PhoneAuthProvider.provider().credential(withVerificationID: verificationID , verificationCode: code)

        Auth.auth().signIn(with: credential) { result, error in
            if error != nil {
                completion(false)
            }
            if result != nil {
                completion(true)
            }
        }
    }
}
