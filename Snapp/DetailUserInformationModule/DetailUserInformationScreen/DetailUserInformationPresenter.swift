//
//  DetailUserInformationPresenter.swift
//  Snapp
//
//  Created by Максим Жуин on 18.06.2024.
//

import UIKit

protocol DetailUserInformationViewProtocol: AnyObject {
    
}

protocol DetailUserInformationPresenterProtocol: AnyObject {
    init(view: DetailUserInformationViewProtocol, mainUser: FirebaseUser)
}

final class DetailUserInformationPresenter: DetailUserInformationPresenterProtocol {

    weak var view: DetailUserInformationViewProtocol?
    var mainUser: FirebaseUser

    init(view: DetailUserInformationViewProtocol, mainUser: FirebaseUser) {
        self.view = view
        self.mainUser = mainUser
    }


}
