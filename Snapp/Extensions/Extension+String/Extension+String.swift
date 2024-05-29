//
//  Extension+String.swift
//  Snapp
//
//  Created by Максим Жуин on 02.04.2024.
//

import Foundation


extension String {
    static func localized(string: String) -> String  {
        NSLocalizedString(string, comment: "")
    }

    static func localizePlurals(key: String, number: Int) -> String {
        let localizedString = NSLocalizedString(key, tableName: "PostCell", comment: "")
        return String(format: localizedString, number)
    }
}
