//
//  ProfileViewController.swift
//  Snapp
//
//  Created by Максим Жуин on 08.04.2024.
//

import UIKit

class ProfileViewController: UIViewController {
// MARK: -PROPERTIES
    var presenter: ProfilePresenterProtocol?

// MARK: -LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
// MARK: -FUNCS
}

// MARK: -OUTPUT PRESENTER
extension ProfileViewController: ProfileViewProtocol {

}
