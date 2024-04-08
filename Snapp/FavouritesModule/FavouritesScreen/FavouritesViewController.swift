//
//  FavouritesViewController.swift
//  Snapp
//
//  Created by Максим Жуин on 08.04.2024.
//

import UIKit

class FavouritesViewController: UIViewController {

    var presenter: FavouritesPresenter!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
    }

}

extension FavouritesViewController: FavouritesViewProtocol {
    
}
