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
    init(view: DataChangeViewProtocol, user: FirebaseUser, firestoreService: FireStoreServiceProtocol, state: DataChangeState)
}

final class DataChangePresenter: DataChangePresenterProtocol {

    weak var view: DataChangeViewProtocol?
    let user: FirebaseUser
    let firestoreService: FireStoreServiceProtocol
    let state: DataChangeState

    init(view: DataChangeViewProtocol, user: FirebaseUser, firestoreService: FireStoreServiceProtocol, state: DataChangeState) {
        self.view = view
        self.user = user
        self.firestoreService = firestoreService
        self.state = state
        checkState()
    }

    func updateData(text: String) async {
        guard let id = user.documentID else { return }
        await firestoreService.changeData(id: id, text: text, state: .name)
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

    func changeCity(text: String) async {
        guard let id = user.documentID else { return }
        await firestoreService.changeData(id: id, text: text, state: .city)
    }

    func changeName(text: String) async {
        guard let id = user.documentID else { return }
        await firestoreService.changeData(id: id, text: text, state: .name)
    }

    func changeSurnamet(text: String) async {
        guard let id = user.documentID else { return }
        await firestoreService.changeData(id: id, text: text, state: .surname)
    }

    func changeDateOfBirth(text: String) async {
        guard let id = user.documentID else { return }
        await firestoreService.changeData(id: id, text: text, state: .job)
    }
}
