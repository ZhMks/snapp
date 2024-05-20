//
//  PhotoalbumPresenter.swift
//  Snapp
//
//  Created by Максим Жуин on 20.05.2024.
//

import UIKit

protocol PhotoalbumViewProtocol: AnyObject {

}

protocol PhotoalbumPresenterProtocol: AnyObject {
    init(view: PhotoalbumViewProtocol)
}

final class PhotoalbumPresenter: PhotoalbumPresenterProtocol {
    weak var view: PhotoalbumViewProtocol?

    init(view: PhotoalbumViewProtocol) {
        self.view = view
    }
}
