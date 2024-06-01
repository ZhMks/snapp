//
//  FireBaseAuthService.swift
//  Snapp
//
//  Created by Максим Жуин on 03.04.2024.
//

import Foundation
import FirebaseAuth

enum AuthorisationErrors: Error {
    case invalidCredential
    case operationNotAllowed
    case userDisabled
    case userAlreadyExist

    var description: String {
        switch self {
        case .invalidCredential:
            return .localized(string: "Учетная запись не действительна")
        case .operationNotAllowed:
            return .localized(string: "Учетная запись не включена. Обратитесь в службу поддержки.")
        case .userDisabled:
            return .localized(string: "Учетная запись отключена")
        case .userAlreadyExist:
            return .localized(string: "Пользователь уже зарегестрирован")
        }
    }
}

protocol FireBaseAuthProtocol {
    var verificationID: String? { get set }
    func signUpUser(phone: String, completion: @escaping (Result<Bool, Error>) -> Void)
    func verifyCode(code: String, completion: @escaping (Result<User, AuthorisationErrors>) -> Void)
    func logOut(completion: @escaping (Result<Void, Error>) -> Void)
}

final class FireBaseAuthService: FireBaseAuthProtocol {

    internal var verificationID: String?

    func signUpUser(phone: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        PhoneAuthProvider.provider().verifyPhoneNumber(phone, uiDelegate: nil) { [weak self] verificationID, error in
            if error != nil {
                completion(.failure(error!))
            }

            if let verificationID = verificationID {
                self?.verificationID = verificationID
                completion(.success(true))
            }
        }
    }

    func verifyCode(code: String, completion: @escaping (Result<User, AuthorisationErrors>) -> Void) {
        guard let verificationID = verificationID else {
            return
        }

        let credential = PhoneAuthProvider.provider().credential(withVerificationID: verificationID , verificationCode: code)

        Auth.auth().signIn(with: credential) { result, error in
            if let error = error {
                switch error.localizedDescription {
                case "FIRAuthErrorCodeInvalidCredential":
                    completion(.failure(.invalidCredential))
                case "FIRAuthErrorCodeOperationNotAllowed":
                    completion(.failure(.operationNotAllowed))
                case "FIRAuthErrorCodeUserDisabled":
                    completion(.failure(.userDisabled))
                default:
                    print("Error: \(error.localizedDescription)")
                }
            }
            if let result = result {
                completion(.success(result.user))
            }
        }
    }

    func logOut(completion: @escaping (Result<Void, any Error>) -> Void) {
        do {
            try Auth.auth().signOut()
            completion(.success(()))
        } catch {
            completion(.failure(error))
        }
    }


}
