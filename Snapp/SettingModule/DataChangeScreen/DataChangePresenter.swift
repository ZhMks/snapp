//
//  DataChangePresenter.swift
//  Snapp
//
//  Created by Максим Жуин on 21.05.2024.
//

import UIKit


enum DataChangeState {
    case mainInformation
    case contacts
    case interests
    case education
    case career
}

protocol DataChangeViewProtocol: AnyObject {

    func layoutForInformationView()
    func layoutForContactsView()
    func layoutForInterestsView()
    func layoutForEducationView()
    func layoutForCareerView()

}

protocol DataChangePresenterProtocol: AnyObject {
    init(view: DataChangeViewProtocol, mainUserID: String, state: DataChangeState)
}

final class DataChangePresenter: DataChangePresenterProtocol {

    weak var view: DataChangeViewProtocol?
    let user: String
    let state: DataChangeState

    init(view: DataChangeViewProtocol, mainUserID: String, state: DataChangeState) {
        self.view = view
        self.user = mainUserID
        self.state = state
        checkState()
    }

    func updateData(text: String)  {
        FireStoreService.shared.changeData(id: user, text: text, state: .name)
    }

    func checkState() {
        switch self.state {
        case .mainInformation:
            view?.layoutForInformationView()
        case .contacts:
            view?.layoutForContactsView()
        case .interests:
            view?.layoutForInterestsView()
        case .education:
            view?.layoutForEducationView()
        case .career:
            view?.layoutForCareerView()
        }
    }

    func changeIdentifier(text: String)  {
        FireStoreService.shared.changeData(id: user, text: text, state: .identifier)
    }

    func changeName(text: String)  {
        FireStoreService.shared.changeData(id: user, text: text, state: .name)
        NotificationCenter.default.post(name: Notification.Name("DataChanged"), object: nil)
    }

    func changeSurname(text: String)  {
        FireStoreService.shared.changeData(id: user, text: text, state: .surname)
        NotificationCenter.default.post(name: Notification.Name("DataChanged"), object: nil)
    }

    func changeDateOfBirth(text: String)  {
        FireStoreService.shared.changeData(id: user, text: text, state: .dateOfBirth)
    }

    func changeInterests(text: String) {
        FireStoreService.shared.changeData(id: user, text: text, state: .interests)
    }

    func changeContacts(text: String) {
        FireStoreService.shared.changeData(id: user, text: text, state: .contacts)
    }

    func changeJob(text: String) {
        FireStoreService.shared.changeData(id: user, text: text, state: .job)
    }

    func changeEducation(text: String) {
        FireStoreService.shared.changeData(id: user, text: text, state: .education)
    }

}
