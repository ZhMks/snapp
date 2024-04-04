//
//  Validator.swift
//  Snapp
//
//  Created by Максим Жуин on 03.04.2024.
//

import UIKit

protocol ValidatorProtocol {
    func validatePhone(string: String) -> Bool
}


final class Validator: ValidatorProtocol {

    static let shared = Validator()

    private init() {}

    func validatePhone(string: String) -> Bool {

        if string.contains("+7") {
            return true
        }
        return false
    }
}
