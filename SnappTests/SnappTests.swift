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

    var verificationID: String?
    
    func signUpUser(phone: String, completion: @escaping (Bool) -> Void) {
        Auth.auth().settings?.isAppVerificationDisabledForTesting = true
        PhoneAuthProvider.provider().verifyPhoneNumber(phone, uiDelegate: nil) { verificationID, error in
            if let _ = error {
                completion(false)
            }
            if let _ = verificationID {
                completion(true)
            }
        }
    }
    
    func verifyCode(code: String, completion: @escaping (Bool) -> Void) {
        Auth.auth().settings?.isAppVerificationDisabledForTesting = true
        let verificationID = ""
        let credential = PhoneAuthProvider.provider().credential(withVerificationID: verificationID, verificationCode: code)
        Auth.auth().signIn(with: credential) { authData, error in
            if let _ = error {
                completion(false)
            }
            if let _ = authData {
                completion(true)
            }
        }
    }
    

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
