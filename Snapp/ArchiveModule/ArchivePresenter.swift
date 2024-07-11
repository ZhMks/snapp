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
    init(view: ArchiveViewProtocol, user: FirebaseUser, mainUser: String)
}

final class ArchivePresenter: ArchivePresenterProtocol {
    weak var view: ArchiveViewProtocol?
    var posts: [EachPost]?
    let mainUser: FirebaseUser
    let mainUserID: String
    let nsLock = NSLock()

    init(view: ArchiveViewProtocol, user: FirebaseUser, mainUser: String) {
        self.view = view
        self.mainUser = user
        self.mainUserID = mainUser
    }

    func fetchPosts() {
        guard let userID = mainUser.documentID else { return }
        FireStoreService.shared.fetchArchives(user: userID) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let archivedPosts):
                self.nsLock.lock()
                self.posts = archivedPosts
                self.nsLock.unlock()
                view?.updateDataView()
            case .failure(let failure):
                view?.showError(error: failure.localizedDescription)
            }
        }
    }
}
