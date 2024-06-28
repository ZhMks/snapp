//
//  SnappTests.swift
//  SnappTests
//
//  Created by Максим Жуин on 01.04.2024.
//

import XCTest
@testable import Snapp
@testable import FirebaseAuth

class MockView: SecondOnboardingViewProtocol {
    func showAuthorisationAlert(error: String) {
        <#code#>
    }
    
    func showAlert() {
    }
}

class MockValidator: ValidatorProtocol {
    func validatePhone(string: String) -> Bool {
        if string.contains("+7") {
            return true
        }
        return false
    }
}

class MocFireBaseAuthService: FireBaseAuthProtocol {
    func signUpUser(phone: String, completion: @escaping (Result<Bool, any Error>) -> Void) {
        Auth.auth().settings?.isAppVerificationDisabledForTesting = true
        PhoneAuthProvider.provider().verifyPhoneNumber(phone, uiDelegate: nil) { verificationID, error in
            if let error = error {
                completion(.failure(error))
            }
            if let _ = verificationID {
                completion(.success(true))
            }
        }
    }
    
    func verifyCode(code: String, completion: @escaping (Result<User, Snapp.AuthorisationErrors>) -> Void) {
        Auth.auth().settings?.isAppVerificationDisabledForTesting = true
        let verificationID = ""
        let credential = PhoneAuthProvider.provider().credential(withVerificationID: verificationID, verificationCode: code)
        Auth.auth().signIn(with: credential) { authData, error in
            if let error = error {
                completion(.failure(.invalidCredential))
            }
            if let data = authData {
                completion(.success(data.user))
            }
        }
    }
    
    func logOut(completion: @escaping (Result<Void, any Error>) -> Void) {
        print()
    }

    var verificationID: String?
}

final class SnappTests: XCTestCase {

    var view: SecondOnboardingViewProtocol!
    var validator: ValidatorProtocol!
    var presenter: SecondOnboardingPresenterProtocol!
    var authService: FireBaseAuthProtocol!

    override func setUpWithError() throws {
        view = MockView()
        validator = MockValidator()
        authService = MocFireBaseAuthService()
        presenter = SecondOnboardingPresenter(view: view, authService: authService)
    }

    override func tearDownWithError() throws {
        view = nil
        validator = nil
    }

    func testRightString() throws {
        let string = "+71651829830"
        let expression = validator.validatePhone(string: string)
        XCTAssertTrue(expression)
    }

    func testWrongString() throws {
        let string = "899022124"
        let expression = validator.validatePhone(string: string)
        XCTAssertFalse(expression)
    }

}
