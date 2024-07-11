//
//  FireBaseAuthService.swift
//  Snapp
//
//  Created by Максим Жуин on 03.04.2024.
//

import Foundation
import FirebaseAuth
import UIKit

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
    /// Функция для создания пользователя в БД.
    /// - Parameters:
    ///   - phone: Телефон по которому будут отправляться проверочные коды.
    ///   - completion: Возвращает либо успех, либо ошибку.
    func signUpUser(phone: String, completion: @escaping (Result<Bool, Error>) -> Void)
    
    /// Функция для получения авторизованного пользователя.
    /// - Parameters:
    ///   - code: Проверочный код
    ///   - completion: Возвращает либо структуру User, которую создает сам Firebase, либо одну из ошибок.
    func verifyCode(code: String, completion: @escaping (Result<User, AuthorisationErrors>) -> Void)
    
    /// Функция для выхода авторизованного пользователя.
    /// - Parameter completion: возвращает либо успех, либо ошибку.
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


    func reloadUser(completion: @escaping (User) -> Void) {
        Auth.auth().currentUser?.reload(completion: { error in
            if error != nil {
                print("Error in reloading user: \(error?.localizedDescription)")
            }
            guard let currentUser = Auth.auth().currentUser else { return }
            completion(currentUser)
        })
    }
}
