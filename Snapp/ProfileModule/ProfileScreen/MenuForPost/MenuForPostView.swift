//
//  MenuForPostViewController.swift
//  Snapp
//
//  Created by Максим Жуин on 20.05.2024.
//

import UIKit

class MenuForPostView: UIView {

    // MARK: -PROPERTIES

    var presenter: MenuForPostPresenter!

    private lazy var addToBookmarkButton: UIButton = {
        let addToBookmarkButton = UIButton(type: .system)
        addToBookmarkButton.translatesAutoresizingMaskIntoConstraints = false
        addToBookmarkButton.setTitle(.localized(string: "Сохранить в закладках"), for: .normal)
        addToBookmarkButton.titleLabel?.font = UIFont(name: "Inter-Light", size: 14)
        addToBookmarkButton.setTitleColor(ColorCreator.shared.createTextColor(), for: .normal)
        return addToBookmarkButton
    }()

    private lazy var pinPostButton: UIButton = {
        let pinPostButton = UIButton(type: .system)
        pinPostButton.translatesAutoresizingMaskIntoConstraints = false
        pinPostButton.setTitle(.localized(string: "Закрепить"), for: .normal)
        pinPostButton.titleLabel?.font = UIFont(name: "Inter-Light", size: 14)
        pinPostButton.setTitleColor(ColorCreator.shared.createTextColor(), for: .normal)
        return pinPostButton
    }()

    private lazy var disableComment: UIButton = {
        let disableComment = UIButton(type: .system)
        disableComment.translatesAutoresizingMaskIntoConstraints = false
        disableComment.setTitle(.localized(string: "Выключить комментирование"), for: .normal)
        disableComment.titleLabel?.font = UIFont(name: "Inter-Light", size: 14)
        disableComment.setTitleColor(ColorCreator.shared.createTextColor(), for: .normal)
        return disableComment
    }()

    private lazy var saveLinkToPost: UIButton = {
        let saveLinkToPost = UIButton(type: .system)
        saveLinkToPost.translatesAutoresizingMaskIntoConstraints = false
        saveLinkToPost.setTitle(.localized(string: "Скопировать ссылку"), for: .normal)
        saveLinkToPost.titleLabel?.font = UIFont(name: "Inter-Light", size: 14)
        saveLinkToPost.setTitleColor(ColorCreator.shared.createTextColor(), for: .normal)
        return saveLinkToPost
    }()

    private lazy var addPostToArchive: UIButton = {
        let addPostToArchive = UIButton(type: .system)
        addPostToArchive.translatesAutoresizingMaskIntoConstraints = false
        addPostToArchive.setTitle(.localized(string: "Архивировать запись"), for: .normal)
        addPostToArchive.titleLabel?.font = UIFont(name: "Inter-Light", size: 14)
        addPostToArchive.setTitleColor(ColorCreator.shared.createTextColor(), for: .normal)
        return addPostToArchive
    }()

    private lazy var deletePost: UIButton = {
        let deletePost = UIButton(type: .system)
        deletePost.translatesAutoresizingMaskIntoConstraints = false
        deletePost.setTitle(.localized(string: "Удалить"), for: .normal)
        deletePost.titleLabel?.font = UIFont(name: "Inter-Light", size: 14)
        deletePost.setTitleColor(ColorCreator.shared.createTextColor(), for: .normal)
        return deletePost
    }()
    // MARK: -LIFECYCLE

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //MARK: -FUNCS

    

}


//MARK: -OUTPUTPRESENTER

extension MenuForPostView: MenuForPostViewProtocol {

}


// MARK: -LAYOUT

extension MenuForPostView {

    func addSubviews() {
        addSubview(addToBookmarkButton)
        addSubview(pinPostButton)
        addSubview(disableComment)
        addSubview(saveLinkToPost)
        addSubview(addPostToArchive)
        addSubview(deletePost)
    }

    func layout() {
        let safeArea = safeAreaLayoutGuide

        NSLayoutConstraint.activate([
            addToBookmarkButton.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 20),
            addToBookmarkButton.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 20),
            addToBookmarkButton.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -60),
            addToBookmarkButton.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -210),

            pinPostButton.topAnchor.constraint(equalTo: addToBookmarkButton.bottomAnchor, constant: 18),
            pinPostButton.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 20),
            pinPostButton.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -180),
            pinPostButton.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -172),

            disableComment.topAnchor.constraint(equalTo: pinPostButton.bottomAnchor, constant: 18),
            disableComment.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 20),
            disableComment.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -30),
            disableComment.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -134),

            saveLinkToPost.topAnchor.constraint(equalTo: disableComment.bottomAnchor, constant: 18),
            saveLinkToPost.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 20),
            saveLinkToPost.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -100),
            saveLinkToPost.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -96),

            addPostToArchive.topAnchor.constraint(equalTo: saveLinkToPost.bottomAnchor, constant: 18),
            addPostToArchive.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 20),
            addPostToArchive.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -70),
            addPostToArchive.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -50),

            deletePost.topAnchor.constraint(equalTo: addPostToArchive.bottomAnchor, constant: 18),
            deletePost.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 20),
            deletePost.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -210),
            deletePost.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -20)
        ])
    }

}
