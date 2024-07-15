//
//  FilesPresenter.swift
//  Snapp
//
//  Created by Максим Жуин on 12.07.2024.
//

import Foundation

protocol FilesViewProtocol: AnyObject {
    func updateData()
}

protocol FilesPresenterProtocol: AnyObject {
    init(view: FilesViewProtocol, mainUser: FirebaseUser)
}

final class FilesPresenter: FilesPresenterProtocol {
    weak var view: FilesViewProtocol?
    var mainUser: FirebaseUser
    let nsLock = NSLock()
    var decodedObjects: [String: Any?]?

    init(view: FilesViewProtocol, mainUser: FirebaseUser) {
        self.view = view
        self.mainUser = mainUser
    }

    func putFileToStorage(file: URL) {
        guard let mainUserID = mainUser.documentID else { return }
        FireStoreService.shared.saveFileIntoStorage(fileURL: file, user: mainUserID) { result in
            switch result {
            case .success(let success):
                FireStoreService.shared.changeData(id: mainUserID, text: success.absoluteString, state: .files)
            case .failure(let failure):
                print(failure.localizedDescription)
            }
        }
    }

    func addUserListener() {
        guard let userID = mainUser.documentID else { return }
        FireStoreService.shared.addSnapshotListenerToUser(for: userID) { [weak self] result in
            switch result {
            case .success(let firebaseUser):
                self?.nsLock.lock()
                self?.mainUser = firebaseUser
                self?.nsLock.unlock()
                self?.getFileFromStorage(user: userID)
            case .failure(let failure):
                print(failure.localizedDescription)
            }
        }
    }

    func getFileFromStorage(user: String) {
        decodedObjects = [:]
        let networkService = NetworkService()
        let decoder = DecoderService()
        let dispatchGroup = DispatchGroup()
        guard let files = mainUser.files else { return }
        for filesURL in files {
            dispatchGroup.enter()
            networkService.fetchFileFrom(urlString: filesURL) { [weak self] result in
                switch result {
                case .success(let success):
                    let decodedItem = decoder.decodeData(fileData: success.0, type: success.1)
                    self?.decodedObjects?.updateValue(decodedItem, forKey: success.2)
                case .failure(let failure):
                    print(failure.localizedDescription)
                }
                dispatchGroup.leave()
            }
        }
        dispatchGroup.notify(queue: .main) { [weak self] in
            self?.view?.updateData()
        }
    }

    func removeUserListener() {
        FireStoreService.shared.removeListenerForUser()
    }
}
