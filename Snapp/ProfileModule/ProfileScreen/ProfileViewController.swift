//
//  ProfileViewController.swift
//  Snapp
//
//  Created by Максим Жуин on 08.04.2024.
//

import UIKit

class ProfileViewController: UIViewController {
// MARK: -PROPERTIES
    var presenter: ProfilePresenter!

// MARK: -LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        tuneNavItem()
    }
    
// MARK: -FUNCS


}

// MARK: -OUTPUT PRESENTER
extension ProfileViewController: ProfileViewProtocol {
}


// MARK: -LAYOUT
extension ProfileViewController {
    func tuneNavItem() {
        let settingsButton = UIBarButtonItem(image: UIImage(systemName: "line.3.horizontal"),
                                             style: .plain,
                                             target: self,
                                             action: #selector(showSettingsVC))
        settingsButton.tintColor = .systemYellow
        self.navigationItem.rightBarButtonItem = settingsButton
    }

    @objc func showSettingsVC() {
        let settingsVC = SettingsViewController()
        let settingsPresenter = SettingPresenter(view: settingsVC, user: presenter.firebaseUser, firestoreService: presenter.firestoreService)
        settingsVC.presenter = settingsPresenter
        navigationController?.present(settingsVC, animated: true)
    }
}
