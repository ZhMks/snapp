//
//  FeedPresenter.swift
//  Snapp
//
//  Created by Максим Жуин on 06.04.2024.
//

import UIKit

protocol FeedViewProtocol: AnyObject {}

protocol FeedPresenterProtocol: AnyObject {
    init(view: FeedViewProtocol, user: UserMainModel)
}


final class FeedPresenter: FeedPresenterProtocol {

    weak var view: FeedViewProtocol?
    let user: UserMainModel

    init(view: FeedViewProtocol, user: UserMainModel) {
        self.view = view
        self.user = user
    }

}
