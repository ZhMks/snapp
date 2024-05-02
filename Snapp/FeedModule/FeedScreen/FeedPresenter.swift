//
//  FeedPresenter.swift
//  Snapp
//
//  Created by Максим Жуин on 06.04.2024.
//

import UIKit
import FirebaseStorage

protocol FeedViewProtocol: AnyObject {
    func showEmptyScreen()
}

protocol FeedPresenterProtocol: AnyObject {
    init(view: FeedViewProtocol, user: FirebaseUser)
}


final class FeedPresenter: FeedPresenterProtocol {

    weak var view: FeedViewProtocol?
    var stories: [UIImage]?
    var userStorie: UIImage?
    var user: FirebaseUser
    var posts: [MainPost]?

    init(view: FeedViewProtocol, user: FirebaseUser) {
        self.view = view
        self.user = user
    }
}
