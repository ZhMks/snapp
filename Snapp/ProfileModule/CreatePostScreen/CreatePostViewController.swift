//
//  CreatePostViewController.swift
//  Snapp
//
//  Created by Максим Жуин on 10.05.2024.
//

import UIKit

class CreatePostViewController: UIViewController {

    // MARK: -Properties

    var presenter: CreatePostPresenter!
    var textViewHeightConstraint: NSLayoutConstraint!

    private lazy var userAvatarImage: UIImageView = {
        let userAvatarImage = UIImageView()
        userAvatarImage.translatesAutoresizingMaskIntoConstraints = false
        userAvatarImage.clipsToBounds = true
        userAvatarImage.image = self.presenter.image
        userAvatarImage.layer.cornerRadius = 10
        return userAvatarImage
    }()

    private lazy var placeHolderLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 5, y: 5, width: 120, height: 20))
        label.text = "Что у вас нового?"
        label.textColor = UIColor.lightGray
        return label
    }()

    private lazy var separatorView: UIView = {
        let separatorView = UIView()
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        separatorView.backgroundColor = .systemGray5
        return separatorView
    }()

    private lazy var createPostTextView: UITextView = {
        let creaPostTextView = UITextView()
        creaPostTextView.translatesAutoresizingMaskIntoConstraints = false
        creaPostTextView.font = UIFont(name: "Inter-Light", size: 18)
        creaPostTextView.textColor = ColorCreator.shared.createTextColor()
        creaPostTextView.textAlignment = .left
        creaPostTextView.delegate = self
        return creaPostTextView
    }()

    private lazy var createPostImageView: UIImageView = {
        let createPostImageView = UIImageView()
        createPostImageView.translatesAutoresizingMaskIntoConstraints = false
        createPostImageView.backgroundColor = .systemYellow
        return createPostImageView
    }()

    private lazy var addImageButton: UIButton = {
        let addImageButton = UIButton()
        addImageButton.translatesAutoresizingMaskIntoConstraints = false
        addImageButton.setBackgroundImage(UIImage(systemName: "photo.circle"), for: .normal)
        addImageButton.tintColor = ColorCreator.shared.createTextColor()
        addImageButton.addTarget(self, action: #selector(addImage), for: .touchUpInside)
        return addImageButton
    }()

    private lazy var sendPostButton: UIButton = {
        let sendPostButton = UIButton(type: .system)
        sendPostButton.translatesAutoresizingMaskIntoConstraints = false
        sendPostButton.setBackgroundImage(UIImage(systemName: "arrowshape.turn.up.right"), for: .normal)
        sendPostButton.tintColor = ColorCreator.shared.createTextColor()
        sendPostButton.addTarget(self, action: #selector(sendPostButtonTapped), for: .touchUpInside)
        sendPostButton.isEnabled = false
        sendPostButton.tintColor = .systemGray3
        return sendPostButton
    }()



    // MARK: -Lifecycle

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(addSelectedImage), name: Notification.Name("imageIsSelected"), object: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        addSubviews()
        layout()
        NotificationCenter.default.addObserver(self, selector: #selector(removePlaceholder), name: Notification.Name("beginEditing"), object: nil)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }

    // MARK: -Funcs

    @objc func sendPostButtonTapped() {
        presenter.createPost(text: createPostTextView.text, image: createPostImageView.image) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(_):
                NotificationCenter.default.post(name: Notification.Name("newPost"), object: nil)
                self.dismiss(animated: true)
            case .failure(let failure):
                print(failure.localizedDescription)
            }
        }
    }

    @objc func addImage() {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        self.present(imagePicker, animated: true)
    }

    func adjustTextViewHeight() {
        let fixedWidth = createPostTextView.frame.size.width
        let newSize = createPostTextView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        textViewHeightConstraint.constant = newSize.height
        view.layoutIfNeeded()
    }

    @objc func addSelectedImage() {
        view.addSubview(createPostImageView)
        createPostImageView.clipsToBounds = true
        createPostImageView.layer.cornerRadius = 20

        NSLayoutConstraint.activate([
            createPostImageView.topAnchor.constraint(equalTo: createPostTextView.bottomAnchor),
            createPostImageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 15),
            createPostImageView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -15),
            createPostImageView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -15)
        ])
    }

    @objc func removePlaceholder() {
        placeHolderLabel.isHidden = true
    }
}

// MARK: -Presenter Output

extension CreatePostViewController: CreatePostViewProtocol {
    func showErrorAlert(error: String) {
        let alertController = UIAlertController(title: error, message: error, preferredStyle: .alert)
        let action = UIAlertAction(title: .localized(string: "Отмена"), style: .cancel)
        alertController.addAction(action)
        navigationController?.present(alertController, animated: true)
    }
    

}

// MARK: -TextField Delegate

extension CreatePostViewController: UITextViewDelegate {

    func textViewDidBeginEditing(_ textView: UITextView) {
        NotificationCenter.default.post(name: Notification.Name("beginEditing"), object: nil)
    }

    func textViewDidChange(_ textView: UITextView) {
       adjustTextViewHeight()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        createPostTextView.becomeFirstResponder()
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        createPostTextView.resignFirstResponder()
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if !textView.text.isEmpty {
            sendPostButton.tintColor = ColorCreator.shared.createButtonColor()
            sendPostButton.isEnabled = true
        } else {
            placeHolderLabel.isHidden = false
        }
    }
}

// MARK: -ImagePicker Controller

extension CreatePostViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

        guard let image = info[.originalImage] as? UIImage else { return }

        createPostImageView.image = image
        NotificationCenter.default.post(name: Notification.Name("imageIsSelected"), object: nil)
        self.dismiss(animated: true)
    }
}


// MARK: -Layout

extension CreatePostViewController {
    func addSubviews() {
        view.addSubview(userAvatarImage)
        view.addSubview(separatorView)
        view.addSubview(createPostTextView)
        createPostTextView.addSubview(placeHolderLabel)
        view.addSubview(addImageButton)
        view.addSubview(sendPostButton)
    }

    func layout() {
        let safeArea = view.safeAreaLayoutGuide

        NSLayoutConstraint.activate([

            userAvatarImage.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 5),
            userAvatarImage.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 310),
            userAvatarImage.heightAnchor.constraint(equalToConstant: 50),
            userAvatarImage.widthAnchor.constraint(equalToConstant: 50),

            sendPostButton.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 5),
            sendPostButton.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 200),
            sendPostButton.heightAnchor.constraint(equalToConstant: 50),
            sendPostButton.widthAnchor.constraint(equalToConstant: 50),

            addImageButton.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 5),
            addImageButton.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 15),
            addImageButton.heightAnchor.constraint(equalToConstant: 50),
            addImageButton.widthAnchor.constraint(equalToConstant: 50),

            separatorView.topAnchor.constraint(equalTo: sendPostButton.bottomAnchor, constant: 5),
            separatorView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 20),
            separatorView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -20),
            separatorView.heightAnchor.constraint(equalToConstant: 1),

            createPostTextView.topAnchor.constraint(equalTo: separatorView.bottomAnchor, constant: 5),
            createPostTextView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 5),
            createPostTextView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -5),
        ])

        textViewHeightConstraint = createPostTextView.heightAnchor.constraint(equalToConstant: 100)
        textViewHeightConstraint.isActive = true
    }
}
