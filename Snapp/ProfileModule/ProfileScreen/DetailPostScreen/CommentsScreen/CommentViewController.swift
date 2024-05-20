//
//  CommentViewController.swift
//  Snapp
//
//  Created by Максим Жуин on 18.05.2024.
//

import UIKit

class CommentViewController: UIViewController {

    //MARK: -PROPERTIES
    var presenter: CommentViewPresenter!

    private lazy var avatarImageView: UIImageView = {
        let avatarImageView = UIImageView()
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        return avatarImageView
    }()

    private lazy var separatorView: UIView = {
        let separatorView = UIView()
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        separatorView.backgroundColor = .systemGray2
        return separatorView
    }()

    private lazy var sendButton: UIButton = {
        let sendButton = UIButton(type: .system)
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        sendButton.setBackgroundImage(UIImage(systemName: "arrow.right"), for: .normal)
        sendButton.tintColor = ColorCreator.shared.createButtonColor()
        sendButton.addTarget(self, action: #selector(sendButtonTapped), for: .touchUpInside)
        return sendButton
    }()

    private lazy var commentTextField: UITextView = {
        let commentTextField = UITextView()
        commentTextField.translatesAutoresizingMaskIntoConstraints = false
        commentTextField.delegate = self
        return commentTextField
    }()

    private lazy var placeHolderLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 5, y: 5, width: 140, height: 20))
        label.text = .localized(string: "Поделиться мнением")
        label.font = UIFont(name: "Inter-Light", size: 14)
        label.textColor = UIColor.lightGray
        return label
    }()

    //MARK: -LIFECYCLE

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(removePlaceholder), name: Notification.Name("beginEditing"), object: nil)
        view.backgroundColor = .systemBackground
        addSubviews()
        layout()
        updateImage()
    }


    // MARK: -FUNCS

    @objc func removePlaceholder() {
        placeHolderLabel.isHidden = true
    }

    @objc func sendButtonTapped() {
        if presenter.user == presenter.commentor {
            presenter.addComment(text: commentTextField.text)
        } else {
            presenter.addAnswer(text: commentTextField.text)
        }
        dismiss(animated: true)
    }
    func updateImage () {
        avatarImageView.image = presenter.image
        avatarImageView.clipsToBounds = true
        avatarImageView.layer.cornerRadius = avatarImageView.frame.size.width / 2
    }
}

// MARK: -OUTPUTPRESENTER
extension CommentViewController: CommentViewProtocol {
    func showError(error: String) {
        print("Error: \(error)")
    }

}

// MARK: -UITEXTFIELDDELEGATE

extension CommentViewController: UITextViewDelegate {

    func textViewDidBeginEditing(_ textView: UITextView) {
        NotificationCenter.default.post(name: Notification.Name("beginEditing"), object: nil)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        commentTextField.becomeFirstResponder()
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        commentTextField.resignFirstResponder()
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if !textView.text.isEmpty {
            sendButton.tintColor = ColorCreator.shared.createButtonColor()
            sendButton.isEnabled = true
        } else {
            placeHolderLabel.isHidden = false
        }
    }
}

    //MARK: - LAYOUT
extension CommentViewController {
    func addSubviews() {
        view.addSubview(avatarImageView)
        view.addSubview(separatorView)
        view.addSubview(sendButton)
        view.addSubview(commentTextField)
        commentTextField.addSubview(placeHolderLabel)
    }

    func layout() {
        let safeArea = view.safeAreaLayoutGuide

        NSLayoutConstraint.activate([
            avatarImageView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 5),
            avatarImageView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 320),
            avatarImageView.heightAnchor.constraint(equalToConstant: 30),
            avatarImageView.widthAnchor.constraint(equalToConstant: 30),

            sendButton.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 5),
            sendButton.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 5),
            sendButton.heightAnchor.constraint(equalToConstant: 30),
            sendButton.widthAnchor.constraint(equalToConstant: 30),

            separatorView.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 5),
            separatorView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 15),
            separatorView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -15),
            separatorView.heightAnchor.constraint(equalToConstant: 1),

            commentTextField.topAnchor.constraint(equalTo: separatorView.bottomAnchor, constant: 15),
            commentTextField.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            commentTextField.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            commentTextField.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor)
        ])
    }
}
