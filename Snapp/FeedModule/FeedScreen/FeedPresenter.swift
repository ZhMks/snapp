//
//  FeedPresenter.swift
//  Snapp
//
//  Created by Максим Жуин on 06.04.2024.
//

import UIKit

protocol FeedViewProtocol: AnyObject {}

protocol FeedPresenterProtocol: AnyObject {
    init(view: FeedViewProtocol, user: FirebaseUser, posts: [String : [String:EachPost]])
}


final class FeedPresenter: FeedPresenterProtocol {

    weak var view: FeedViewProtocol?
    let user: FirebaseUser
    let posts: [String : [String:EachPost]]

    init(view: FeedViewProtocol, user: FirebaseUser, posts: [String : [String: EachPost]]) {
        self.view = view
        self.user = user
        self.posts = posts
    }

}
