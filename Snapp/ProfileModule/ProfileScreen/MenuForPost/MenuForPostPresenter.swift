//
//  MenuForPostPresenter.swift
//  Snapp
//
//  Created by Максим Жуин on 20.05.2024.
//

import UIKit

protocol MenuForPostViewProtocol: AnyObject {

}

protocol MenuForPostPresenterProtocol: AnyObject {
    init(view: MenuForPostViewProtocol)
}


final class MenuForPostPresenter: MenuForPostPresenterProtocol {
    weak var view: MenuForPostViewProtocol?

    init(view: MenuForPostViewProtocol) {
        self.view = view
    }
}
