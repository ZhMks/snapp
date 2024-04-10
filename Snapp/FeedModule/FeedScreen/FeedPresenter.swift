//
//  FeedPresenter.swift
//  Snapp
//
//  Created by Максим Жуин on 06.04.2024.
//

import UIKit

protocol FeedViewProtocol: AnyObject {}

protocol FeedPresenterProtocol: AnyObject {
    init(view: FeedViewProtocol, user: UserMainModel, posts: [PostsMainModel], eachPost: [EachPostModel])
}


final class FeedPresenter: FeedPresenterProtocol {

    weak var view: FeedViewProtocol?
    let user: UserMainModel
    let posts: [PostsMainModel]
    let eachPost: [EachPostModel]

    init(view: FeedViewProtocol, user: UserMainModel, posts: [PostsMainModel], eachPost: [EachPostModel]) {
        self.view = view
        self.user = user
        self.posts = posts
        self.eachPost = eachPost
    }

}
