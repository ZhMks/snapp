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
    init(view: DetailUserInformationViewProtocol, mainUser: FirebaseUser, mainUserID: String)
}

final class DetailUserInformationPresenter: DetailUserInformationPresenterProtocol {

    weak var view: DetailUserInformationViewProtocol?
    let mainUser: FirebaseUser
    let mainUserID: String

    init(view: DetailUserInformationViewProtocol, mainUser: FirebaseUser, mainUserID: String) {
        self.view = view
        self.mainUser = mainUser
        self.mainUserID = mainUserID
    }


}
