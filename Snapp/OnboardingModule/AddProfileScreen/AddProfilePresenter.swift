//
//  AddProfilePresenter.swift
//  Snapp
//
//  Created by Максим Жуин on 11.04.2024.
//

import UIKit
import FirebaseAuth
import FirebaseStorage

protocol AddProfileViewProtocol: AnyObject {

}

protocol AddProfilePresenterProtocol: AnyObject {
    init(view: AddProfileViewProtocol)
}



final class AddProfilePresenter: AddProfilePresenterProtocol {

    weak var view: AddProfileViewProtocol?

    init(view: AddProfileViewProtocol) {
        self.view = view
    }

    func createUser(id: String,
                    name: String,
                    surname: String,
                    job: String,
                    image: UIImage,
                    completion: @escaping (Result <FirebaseUser, Error>) -> Void) {
        guard let identifier = Auth.auth().currentUser?.uid else { return }
        let ref = Storage.storage().reference().child("users").child(identifier).child("avatar")
        var firebaseUser = FirebaseUser(name: name,
                                        surname: surname,
                                        identifier: id,
                                        job: job,
                                        subscribers: [],
                                        subscribtions: [],
                                        stories: [],
                                        image: "",
                                        photoAlbum: [],
                                        sex: false)
        FireStoreService.shared.saveImageIntoStorage(urlLink: ref, photo: image) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let success):
                firebaseUser.image = success.absoluteString
                FireStoreService.shared.createUser(user: firebaseUser, id: identifier)
                completion(.success(firebaseUser))
            case .failure(let failure):
                print(failure.localizedDescription)
            }
        }
    }
}
