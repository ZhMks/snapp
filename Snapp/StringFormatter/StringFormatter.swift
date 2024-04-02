//
//  StringFormatter.swift
//  Snapp
//
//  Created by Максим Жуин on 02.04.2024.
//

import Foundation
import UIKit

final class StringFormatter {

    static let shared = StringFormatter()

    private init() {}


    func phoneNumberFormat(string: String, shouldRemoveLastDigit: Bool) -> String {

        guard (shouldRemoveLastDigit && string.count <= 2)  else { return "+"}
            let maxNumber = 11
            let regex = try? NSRegularExpression(pattern: "[\\+\\s-\\(\\)]", options: .caseInsensitive)
            let range = NSString(string: string).range(of: string)

            guard var number = regex?.stringByReplacingMatches(in: string, range: range, withTemplate: "") else { return "" }
            print(number)

            if number.count > maxNumber {
                let maxIndex = number.index(number.startIndex, offsetBy: maxNumber)
                number = String(number[number.startIndex ..< maxIndex])
            }

            if shouldRemoveLastDigit {
                let maxIndex = number.index(number.startIndex, offsetBy: number.count - 1)
                number = String(number[number.startIndex ..< maxIndex])
            }

            let maxIndex = number.index(number.startIndex, offsetBy: number.count)
            let regRange = number.startIndex ..< maxIndex

            if number.count < 7 {
              let pattern = "(\\d)(\\d{3})(\\d+))"
               number = number.replacingOccurrences(of: pattern, with: "$1 ($2) $3", options: .regularExpression, range: regRange)
            } else {
                let pattern = "(\\d)(\\d{3})(\\d{3})(\\d{2})(\\d+))"
                number = number.replacingOccurrences(of: pattern, with: "$1 ($2) $3-$4-$5", options: .regularExpression, range: regRange)
            }

            return "+" + number
    }
}
