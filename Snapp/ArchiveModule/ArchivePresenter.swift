//
//  ArchivePresenter.swift
//  Snapp
//
//  Created by Максим Жуин on 15.06.2024.
//

import UIKit

protocol ArchiveViewProtocol: AnyObject {
    func showError(error: String)
    func updateDataView()
}


protocol ArchivePresenterProtocol: AnyObject {
    init(view: ArchiveViewProtocol, user: FirebaseUser, firestoreService: FireStoreServiceProtocol, mainUser: String)
}

final class ArchivePresenter: ArchivePresenterProtocol {
    weak var view: ArchiveViewProtocol?
    var posts: [EachPost]?
    let mainUser: FirebaseUser
    let firestoreService: FireStoreServiceProtocol
    let mainUserID: String

    init(view: ArchiveViewProtocol, user: FirebaseUser, firestoreService: FireStoreServiceProtocol, mainUser: String) {
        self.view = view
        self.mainUser = user
        self.firestoreService = firestoreService
        self.mainUserID = mainUser
    }

    private func fetchPosts() {
        guard let userID = mainUser.documentID else { return }
        firestoreService.fetchArchives(user: userID) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let archivedPosts):
                self.posts = archivedPosts
                view?.updateDataView()
            case .failure(let failure):
                view?.showError(error: failure.localizedDescription)
            }
        }
    }
}
