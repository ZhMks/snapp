//
//  BookmarksPresenter.swift
//  Snapp
//
//  Created by Максим Жуин on 15.06.2024.
//

import UIKit

protocol BookmarksViewProtocol: AnyObject {
    func showError()
    func updateTableView()
    func showError(error: String)
}

protocol BookmarksPresenterProtocol: AnyObject {
    init(view: BookmarksViewProtocol, user: FirebaseUser, mainUser: String)
}


final class BookmarksPresenter: BookmarksPresenterProtocol {
    weak var view: BookmarksViewProtocol?
    let user: FirebaseUser
    var posts: [[FirebaseUser: EachPost]]?
    let mainUserID: String
   

    init(view: BookmarksViewProtocol, user: FirebaseUser, mainUser: String) {
        self.view = view
        self.user = user
        self.mainUserID = mainUser
        fetchBookmarkedPosts()
    }

    func fetchBookmarkedPosts() {
        let dispatchGroup = DispatchGroup()
        let lock = NSLock()
        posts = []
        FireStoreService.shared.fetchBookmarkedPosts(user: mainUserID) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let bookmarkedPosts):
                for post in bookmarkedPosts {
                    dispatchGroup.enter()
                    fetchUserData(id: post.userHoldingPost) { [weak self] result in
                        switch result {
                        case .success(let user):
                            let dict = [user: post]
                            lock.lock()
                            self?.posts?.append(dict)
                            lock.unlock()
                        case .failure(_):
                            return
                        }
                    }
                    dispatchGroup.leave()
                }
            case .failure(let error):
                view?.showError(error: error.localizedDescription)
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            print("Final posts count: \(self?.posts?.count)")
            self?.view?.updateTableView()
        }
    }

    private func fetchUserData(id: String, completion: @escaping (Result<FirebaseUser, Error>) -> Void) {
        FireStoreService.shared.getUser(id: id) { result in
            switch result {
            case .success(let user):
                completion(.success(user))
            case .failure(let failure):
                completion(.failure(failure))
            }
        }
    }
}
