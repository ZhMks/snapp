//
//  DetailPresenter.swift
//  Snapp
//
//  Created by Максим Жуин on 22.04.2024.
//

import UIKit


protocol DetailViewProtocol: AnyObject {

}

protocol DetailPresenterProtocol: AnyObject {
    init(view: DetailViewProtocol, user: FirebaseUser, eachPosts: [EachPost])
}

final class DetailPresenter: DetailPresenterProtocol {

    weak var view: DetailViewProtocol?
    var user: FirebaseUser
    var posts: [EachPost]

    init(view: DetailViewProtocol, user: FirebaseUser, eachPosts: [EachPost]) {
        self.view = view
        self.user = user
        self.posts = eachPosts
    }
}
