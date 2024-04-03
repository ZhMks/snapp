//
//  Validator.swift
//  Snapp
//
//  Created by Максим Жуин on 03.04.2024.
//

import UIKit


final class Validator {

    static let shared = Validator()

    private init() {}

    func validatePhone(string: String) -> Bool {

        if string.contains("+7") {
            return true
        }
        return false
    }
}
