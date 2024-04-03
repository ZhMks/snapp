//
//  Extension+UIColor.swift
//  Snapp
//
//  Created by Максим Жуин on 03.04.2024.
//

import UIKit


extension UIColor {
    static func createColor(lightMode: UIColor, darkMode: UIColor) -> UIColor {
        guard #available(iOS 13.0, *) else {
            return lightMode
        }
        return UIColor { (traitCollection) -> UIColor in
            return traitCollection.userInterfaceStyle == .light ? lightMode :
            darkMode
        }
    }
}


class ColorCreator {
    static let shared = ColorCreator()

    private init() {}

    func createButtonColor() -> UIColor {
        let color = UIColor.createColor(lightMode: UIColor(named: "ButtonColor") ?? UIColor(red: 43/255, green: 57/255, blue: 64/255, alpha: 1),
                                        darkMode: UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.7))
        return color
    }

    func createTextColor() -> UIColor {
        let color = UIColor.createColor(lightMode: .black, darkMode: .white)
        return color
    }
}
