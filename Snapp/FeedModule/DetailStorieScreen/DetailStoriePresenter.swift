//
//  DetailStoriePresenter.swift
//  Snapp
//
//  Created by Максим Жуин on 06.07.2024.
//

import UIKit

protocol DetailStorieViewProtocol: AnyObject {
    func showError(descr: String)
    func updateView(images: [UIImage])
}

protocol DetailStoriePresenterProtocol: AnyObject {
    init(view: DetailStorieViewProtocol, mainUser: FirebaseUser)
}

final class DetailStoriePresenter: DetailStoriePresenterProtocol {

    weak var view: DetailStorieViewProtocol?
    var storieImages: [UIImage]?
    let mainUser: FirebaseUser

    init(view: DetailStorieViewProtocol, mainUser: FirebaseUser ) {
        self.view = view
        self.mainUser = mainUser
    }

    func fetchSubscribersStorie() {
        let networkService = NetworkService()
        let dispatchGroup = DispatchGroup()
        storieImages = []

        for storie in mainUser.stories {
            dispatchGroup.enter()
            networkService.fetchImage(string: storie) { [weak self] result in
                switch result {
                case .success(let image):
                    print("Image Fetched: \(image)")
                    self?.storieImages?.append(image)
                case .failure(let failure):
                    self?.view?.showError(descr: failure.localizedDescription)
                }
                dispatchGroup.leave()
            }
        }
        dispatchGroup.notify(queue: .main) { [weak self] in
            print("user Stories: \(self?.storieImages)")
            guard let imagesArray = self?.storieImages else { return }
            self?.view?.updateView(images: imagesArray)
        }
    }
}
