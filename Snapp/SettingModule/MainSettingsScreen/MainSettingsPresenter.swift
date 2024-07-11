//
//  SettingPresenter.swift
//  Snapp
//
//  Created by Максим Жуин on 08.04.2024.
//

import UIKit


protocol MainSettingsViewProtocol: AnyObject {

}

protocol MainSettingsPresenterProtocol: AnyObject {
    init(view: MainSettingsViewProtocol?, user: FirebaseUser)
}

final class MainSettingsPresenter: MainSettingsPresenterProtocol {
   weak var view: MainSettingsViewProtocol?
    var user: FirebaseUser

    init(view: MainSettingsViewProtocol?, user: FirebaseUser) {
        self.view = view
        self.user = user
    }
}
