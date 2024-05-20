//
//  CommentViewPresenter.swift
//  Snapp
//
//  Created by Максим Жуин on 18.05.2024.
//

import UIKit


protocol CommentViewProtocol: AnyObject {
    func showError(error: String)
}

protocol CommentPresenterProtocol: AnyObject {
    init(view: CommentViewProtocol, image: UIImage, user: String, documentID: String, commentor: String, firestoreService: FireStoreServiceProtocol)
}

final class CommentViewPresenter: CommentPresenterProtocol {
    let user: String
    let documentID: String
    weak var view: CommentViewProtocol?
    let commentor: String
    let firestoreService: FireStoreServiceProtocol
    let image: UIImage
    var commentID: String?

    init(view: any CommentViewProtocol, image: UIImage, user: String,  documentID: String, commentor: String, firestoreService: any FireStoreServiceProtocol) {
        self.view = view
        self.image = image
        self.user = user
        self.documentID = documentID
        self.commentor = commentor
        self.firestoreService = firestoreService
    }
    
    func addComment(text: String) {
        print("CommentID: \(commentID)")
        print("Commentor: \(commentor)")
        print("User owner of detailPostPage: \(user)")
        print("DetailPostDocID: \(documentID)")
        firestoreService.addComment(mainUser: user, text: text, documentID: documentID, commentor: commentor) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(_):
                NotificationCenter.default.post(name: Notification.Name("commentAdded"), object: nil)
            case .failure(let failure):
                view?.showError(error: failure.localizedDescription)
            }
        }
    }

    func addAnswer(text: String) {
        print("CommentID: \(commentID)")
        print("Commentor: \(commentor)")
        print("User owner of detailPostPage: \(user)")
        print("DetailPostDocID: \(documentID)")
        guard let commentID = self.commentID else { return }
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        let stringFromDate = dateFormatter.string(from: date)

        let answer = Answer(text: text, commentor: commentor, date: stringFromDate, likes: 0)
        firestoreService.addAnswerToComment(postID: documentID, user: user, commentID: commentID, answer: answer) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let success):
                NotificationCenter.default.post(name: Notification.Name("answerAdded"), object: nil)
            case .failure(let failure):
                view?.showError(error: failure.localizedDescription)
            }
        }
    }
}
