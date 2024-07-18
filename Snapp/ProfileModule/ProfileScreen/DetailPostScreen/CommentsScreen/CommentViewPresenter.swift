//
//  CommentViewPresenter.swift
//  Snapp
//
//  Created by Максим Жуин on 18.05.2024.
//

import UIKit


enum CommentState {
    case answer
    case comment
}


protocol CommentViewProtocol: AnyObject {
    func showError(error: String)
}

protocol CommentPresenterProtocol: AnyObject {
    init(view: CommentViewProtocol, image: UIImage, user: String, documentID: String, commentor: String, state: CommentState, userState: UserState)
}

final class CommentViewPresenter: CommentPresenterProtocol {
    let user: String
    let documentID: String
    weak var view: CommentViewProtocol?
    let commentor: String
    let image: UIImage
    var commentID: String?
    let state: CommentState
    let userState: UserState

    init(view: any CommentViewProtocol, image: UIImage, user: String,  documentID: String, commentor: String, state: CommentState, userState: UserState) {
        self.view = view
        self.image = image
        self.user = user
        self.documentID = documentID
        self.commentor = commentor
        self.state = state
        self.userState = userState
    }
    
    func addComment(text: String) {
        switch userState {
        case .mainUser:
            if !text.isEmpty {
                FireStoreService.shared.addComment(mainUser: user, text: text, documentID: documentID, commentor: user) { [weak self] result in
                    guard let self else { return }
                    switch result {
                    case .success(_):
                        NotificationCenter.default.post(name: Notification.Name("commentAdded"), object: nil)
                    case .failure(let failure):
                        view?.showError(error: failure.localizedDescription)
                    }
                }
            } else {
                return
            }
        case .notMainUser:
            if !text.isEmpty {
                FireStoreService.shared.addComment(mainUser: user, text: text, documentID: documentID, commentor: commentor) { [weak self] result in
                    guard let self else { return }
                    switch result {
                    case .success(_):
                        NotificationCenter.default.post(name: Notification.Name("commentAdded"), object: nil)
                    case .failure(let failure):
                        view?.showError(error: failure.localizedDescription)
                    }
                }
            } else {
                return
            }
        }
    }

    func addAnswer(text: String) {
        guard let commentID = self.commentID else { return }
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM"
        let stringFromDate = dateFormatter.string(from: date)

        let answer = Answer(text: text, commentor: commentor, date: stringFromDate)

        FireStoreService.shared.addAnswerToComment(postID: documentID, user: user, commentID: commentID, answer: answer) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(_):
                NotificationCenter.default.post(name: Notification.Name("answerAdded"), object: nil)
            case .failure(let failure):
                view?.showError(error: failure.localizedDescription)
            }
        }
    }
}
