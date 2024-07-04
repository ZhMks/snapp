//
//  SettingPresenter.swift
//  Snapp
//
//  Created by Максим Жуин on 08.04.2024.
//

import UIKit


protocol SettingsViewProtocol: AnyObject {

}

protocol SettingsPresenterProtocol: AnyObject {
    init(view: SettingsViewProtocol?, user: FirebaseUser)
}

final class SettingPresenter: SettingsPresenterProtocol {
   weak var view: SettingsViewProtocol?
    var user: FirebaseUser

    init(view: SettingsViewProtocol?, user: FirebaseUser) {
        self.view = view
        self.user = user
    }
}
