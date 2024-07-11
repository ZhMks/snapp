//
//  SettingChangePresenter.swift
//  Snapp
//
//  Created by Максим Жуин on 11.07.2024.
//

import Foundation


protocol SettingChangeViewProtocol: AnyObject {

}

protocol SettingChangePresenterProtocol: AnyObject {
    init(view: SettingChangeViewProtocol)
}

final class SettingChangePresenter: SettingChangePresenterProtocol {
    
    weak var view: SettingChangeViewProtocol?

    init(view: SettingChangeViewProtocol) {
        self.view = view
    }

}
