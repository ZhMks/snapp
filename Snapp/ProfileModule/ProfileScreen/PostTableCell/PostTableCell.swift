//
//  PostTableCell.swift
//  Snapp
//
//  Created by Максим Жуин on 03.05.2024.
//

import UIKit


final class PostTableCell: UITableViewCell {

    //MARK: -PROPERTIES
    static let identifier = "PostTableCell"

    private lazy var verticalView: UIView = {
        let verticalView = UIView()
        verticalView.translatesAutoresizingMaskIntoConstraints = false
        verticalView.backgroundColor = .systemGray
        return verticalView
    }()

    private lazy var postTextView: UILabel = {
        let postTextView = UILabel()
        postTextView.numberOfLines = 0
        postTextView.translatesAutoresizingMaskIntoConstraints = false
        return postTextView
    }()

    private lazy var postImage: UIImageView = {
        let postImage = UIImageView()
        postImage.translatesAutoresizingMaskIntoConstraints = false
        return postImage
    }()

    // MARK: -LIFECYCLE

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        addSubviews()
        layout()
        contentView.backgroundColor = .systemGray2
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: -FUNCS

    func updateView(post: EachPost) {
        postTextView.text = post.text
        let networkService = NetworkService()
        networkService.fetchImage(string: post.image) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let success):
                DispatchQueue.main.async {
                    guard let image = UIImage(data: success) else { return }
                    self.postImage.image = image
                    self.postImage.clipsToBounds = true
                    self.postImage.layer.cornerRadius = 30
                }
            case .failure(let failure):
                return
            }
        }
    }


    // MARK: -LAYOUT

    private func addSubviews() {
        contentView.addSubview(verticalView)
        contentView.addSubview(postTextView)
        contentView.addSubview(postImage)
    }

    private func layout() {
        let safeArea = contentView.safeAreaLayoutGuide

        NSLayoutConstraint.activate([
            verticalView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 16),
            verticalView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 31),
            verticalView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -361),
            verticalView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -76),

            postTextView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 10),
            postTextView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 52),
            postTextView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -15),
            postTextView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -198),

            postImage.topAnchor.constraint(equalTo: postTextView.bottomAnchor, constant: 10),
            postImage.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 52),
            postImage.widthAnchor.constraint(equalToConstant: 300),
            postImage.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -10)
        ])
    }

}
