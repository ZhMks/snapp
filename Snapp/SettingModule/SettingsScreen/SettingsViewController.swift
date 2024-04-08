//
//  SettingsViewController.swift
//  Snapp
//
//  Created by Максим Жуин on 08.04.2024.
//

import UIKit

class SettingsViewController: UIViewController {
    var presenter: SettingPresenter!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .yellow

        print(presenter.user)
    }
    
}

extension SettingsViewController: SettingsViewProtocol {}
