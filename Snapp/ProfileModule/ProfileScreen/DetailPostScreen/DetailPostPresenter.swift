//
//  DetailPostPresenter.swift
//  Snapp
//
//  Created by Максим Жуин on 14.05.2024.
//

import UIKit

protocol DetailPostViewProtocol: AnyObject {
    func updateImageView(image: UIImage)
}

protocol DetailPostPresenterProtocol: AnyObject {
    init(view: DetailPostViewProtocol, user: FirebaseUser, post: EachPost, image: UIImage)
}

final class DetailPostPresenter: DetailPostPresenterProtocol {

    weak var view: DetailPostViewProtocol?
    let user: FirebaseUser
    let post: EachPost
    let image: UIImage

    init(view: DetailPostViewProtocol, user: FirebaseUser, post: EachPost, image: UIImage) {
        self.view = view
        self.user = user
        self.post = post
        self.image = image
        fetchPostImage()
    }

    func fetchPostImage() {
        if let image = post.image {
            let networkService = NetworkService()
            networkService.fetchImage(string: image) { [weak self] result in
                guard let self else { return }
                switch result {
                case .success(let success):
                    print("success")
                    guard let image = UIImage(data: success) else { return }
                    self.view?.updateImageView(image: image)
                case .failure(let failure):
                    print(failure.localizedDescription)
                }
            }
        }
    }
}
