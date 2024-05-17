//
//  DetailPostViewController.swift
//  Snapp
//
//  Created by Максим Жуин on 14.05.2024.
//

import UIKit

class DetailPostViewController: UIViewController {

    // MARK: -PROPERTIES
    var presenter: DetailPostPresenter!

    private lazy var detailPostView: UIView = {
        let detailPostView = UIView()
        detailPostView.translatesAutoresizingMaskIntoConstraints = false
        detailPostView.backgroundColor = .systemBackground
        return detailPostView
    }()
    private lazy var topSeparatorView: UIView = {
        let topSeparatorView = UIView()
        topSeparatorView.translatesAutoresizingMaskIntoConstraints = false
        topSeparatorView.backgroundColor = .systemGray4
        return topSeparatorView
    }()

    private lazy var avatarImageView: UIImageView = {
        let avatarImageView = UIImageView()
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        avatarImageView.image = presenter.image
        avatarImageView.clipsToBounds = true
        return avatarImageView
    }()

    private lazy var identifierLabel: UILabel = {
        let identifierLabel = UILabel()
        identifierLabel.translatesAutoresizingMaskIntoConstraints = false
        identifierLabel.font = UIFont(name: "Inter-Light", size: 12)
        identifierLabel.textColor = .systemOrange
        identifierLabel.text = presenter.user.identifier
        return identifierLabel
    }()

    private lazy var jobLabel: UILabel = {
        let jobLabel = UILabel()
        jobLabel.translatesAutoresizingMaskIntoConstraints = false
        jobLabel.textColor = .systemGray3
        jobLabel.font = UIFont(name: "Inter-Light", size: 12)
        jobLabel.text = presenter.user.job
        return jobLabel
    }()

    private lazy var postImageView: UIImageView = {
        let postImageView = UIImageView()
        postImageView.translatesAutoresizingMaskIntoConstraints = false
        postImageView.layer.cornerRadius = 5
        postImageView.clipsToBounds = true
        return postImageView
    }()

    private lazy var postTextLabel: UILabel = {
        let postTextLabel = UILabel()
        postTextLabel.translatesAutoresizingMaskIntoConstraints = false
        postTextLabel.font = UIFont(name: "Inter-Light", size: 14)
        postTextLabel.textColor = ColorCreator.shared.createTextColor()
        postTextLabel.text = presenter.post.text
        postTextLabel.numberOfLines = 0
        postTextLabel.setContentCompressionResistancePriority(.required, for: .vertical)
        postTextLabel.textAlignment = .left
        postTextLabel.sizeToFit()
        return postTextLabel
    }()

    private lazy var likeButton: UIButton = {
        let likeButton = UIButton(type: .system)
        likeButton.translatesAutoresizingMaskIntoConstraints = false
        likeButton.setBackgroundImage(UIImage(systemName: "heart"), for: .normal)
        likeButton.tintColor = ColorCreator.shared.createButtonColor()
        return likeButton
    }()

    private lazy var likesLabel: UILabel = {
        let likesLabel = UILabel()
        likesLabel.translatesAutoresizingMaskIntoConstraints = false
        likesLabel.font = UIFont(name: "Inter-Light", size: 14)
        likesLabel.textColor = ColorCreator.shared.createTextColor()
        return likesLabel
    }()

    private lazy var commentsButton: UIButton = {
        let commentsButton = UIButton(type: .system)
        commentsButton.translatesAutoresizingMaskIntoConstraints = false
        commentsButton.setBackgroundImage(UIImage(systemName: "bubble"), for: .normal)
        commentsButton.tintColor = ColorCreator.shared.createButtonColor()
        return commentsButton
    }()

    private lazy var commentsLabel: UILabel = {
        let commentsLabel = UILabel()
        commentsLabel.translatesAutoresizingMaskIntoConstraints = false
        commentsLabel.font = UIFont(name: "Inter-Light", size: 14)
        commentsLabel.textColor = ColorCreator.shared.createTextColor()
        return commentsLabel
    }()

    private lazy var bookmarkButton: UIButton = {
        let bookmarkButton = UIButton(type: .system)
        bookmarkButton.translatesAutoresizingMaskIntoConstraints = false
        bookmarkButton.setBackgroundImage(UIImage(systemName: "bookmark"), for: .normal)
        bookmarkButton.tintColor = .systemOrange
        return bookmarkButton
    }()

    private lazy var separatorView: UIView = {
        let separatorView = UIView()
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        separatorView.backgroundColor = .systemGray5
        return separatorView
    }()

    private lazy var tableViewTitle: UILabel = {
        let tableViewTitle = UILabel()
        tableViewTitle.translatesAutoresizingMaskIntoConstraints = false
        tableViewTitle.font = UIFont(name: "Inter-Light", size: 14)
        tableViewTitle.textColor = .systemGray4
        tableViewTitle.text = .localized(string: "Комментарии")
        tableViewTitle.sizeToFit()
        tableViewTitle.numberOfLines = 0
        return tableViewTitle
    }()

    private lazy var commentsTableView: UITableView = {
        let commentsTableView = UITableView()
        commentsTableView.translatesAutoresizingMaskIntoConstraints = false
        return commentsTableView
    }()

    private lazy var addCommentView: UIView = {
        let addCommentView = UIView()
        addCommentView.translatesAutoresizingMaskIntoConstraints = false
        addCommentView.backgroundColor = .systemGray5
        return addCommentView
    }()

    private lazy var addCommentImage: UIImageView = {
        let addCommentImage = UIImageView()
        addCommentImage.translatesAutoresizingMaskIntoConstraints = false
        addCommentImage.image = UIImage(systemName: "paperclip")
        addCommentImage.tintColor = ColorCreator.shared.createButtonColor()
        return addCommentImage
    }()

    private lazy var addCommentLabel: UILabel = {
        let addCommentLabel = UILabel()
        addCommentLabel.translatesAutoresizingMaskIntoConstraints = false
        addCommentLabel.font = UIFont(name: "Inter-Light", size: 12)
        addCommentLabel.textColor = .systemGray4
        addCommentLabel.text = .localized(string: "оставить комментарий")
        return addCommentLabel
    }()

    // MARK: -LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        addSubviews()
        layout()
        tuneNavItem()
        tuneTableView()
        view.backgroundColor = .systemBackground
    }


    // MARK: -FUNCS

    func tuneNavItem() {
        let settingsButton = UIBarButtonItem(image: UIImage(named: "menu"),
                                             style: .plain,
                                             target: self,
                                             action: #selector(showSettingsVC))
        settingsButton.tintColor = .systemOrange
        self.navigationItem.rightBarButtonItem = settingsButton

        let textView = UIView(frame: CGRect(x: 0, y: 0, width: 80, height: 30))

        let title = UILabel(frame: CGRect(x: 40, y: 0, width: 80, height: 30))
        title.text = .localized(string: "Публикации")
        title.font = UIFont(name: "Inter-Medium", size: 14)

        let leftArrowButton = UIButton(type: .system)
        leftArrowButton.frame = CGRect(x: 0, y: 0, width: 25, height: 25)
        leftArrowButton.setBackgroundImage(UIImage(systemName: "arrow.left"), for: .normal)
        leftArrowButton.tintColor = .systemOrange
        leftArrowButton.addTarget(self, action: #selector(dismissViewController), for: .touchUpInside)

        textView.addSubview(title)
        textView.addSubview(leftArrowButton)
        let leftButton = UIBarButtonItem(customView: textView)
        self.navigationItem.leftBarButtonItem = leftButton
    }

    @objc func showSettingsVC() {

    }

    @objc func dismissViewController() {
        self.navigationController?.popViewController(animated: true)
    }

    func tuneTableView() {
       // commentsTableView.register(PostTableCell.self, forCellReuseIdentifier: PostTableCell.identifier)
        commentsTableView.rowHeight = UITableView.automaticDimension
        commentsTableView.estimatedRowHeight = 44.0
        commentsTableView.setAndLayout(header: detailPostView)
        commentsTableView.tableFooterView = UIView()
        commentsTableView.separatorStyle = .none
     //   self.commentsTableView.reloadData()
    }
}


// MARK: -OUTPUTPRESENTER
extension DetailPostViewController: DetailPostViewProtocol {
    func updateImageView(image: UIImage) {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            postImageView.image = image

            detailPostView.addSubview(postImageView)

            NSLayoutConstraint.activate([
                postImageView.topAnchor.constraint(equalTo: jobLabel.bottomAnchor, constant: 12),
                postImageView.leadingAnchor.constraint(equalTo: detailPostView.leadingAnchor, constant: 16),
                postImageView.trailingAnchor.constraint(equalTo: detailPostView.trailingAnchor, constant: -16),
                postImageView.heightAnchor.constraint(greaterThanOrEqualToConstant: 212),

                postTextLabel.topAnchor.constraint(equalTo: postImageView.bottomAnchor, constant: 15),
                postTextLabel.leadingAnchor.constraint(equalTo: detailPostView.leadingAnchor, constant: 16),
                postTextLabel.trailingAnchor.constraint(equalTo: detailPostView.trailingAnchor, constant: -16)
            ])
        }
    }
}

//MARK: -TABLEVIEWDATATSOURCE
extension DetailPostViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    

}


//MARK: -TABLEVIEWDELEGATE
extension DetailPostViewController: UITableViewDelegate {

}

// MARK: -LAYOUT

extension DetailPostViewController {
    func addSubviews() {
        view.addSubview(commentsTableView)
        detailPostView.addSubview(topSeparatorView)
        detailPostView.addSubview(topSeparatorView)
        detailPostView.addSubview(avatarImageView)
        detailPostView.addSubview(identifierLabel)
        detailPostView.addSubview(jobLabel)
        detailPostView.addSubview(postTextLabel)
        detailPostView.addSubview(likeButton)
        detailPostView.addSubview(likesLabel)
        detailPostView.addSubview(commentsButton)
        detailPostView.addSubview(commentsLabel)
        detailPostView.addSubview(bookmarkButton)
        detailPostView.addSubview(separatorView)
        detailPostView.addSubview(tableViewTitle)
        view.addSubview(addCommentView)
        addCommentView.addSubview(addCommentImage)
        addCommentView.addSubview(addCommentLabel)

    }

    func layout() {
        avatarImageView.layer.cornerRadius = avatarImageView.frame.size.width / 2

        let safeArea = view.safeAreaLayoutGuide

        NSLayoutConstraint.activate([
            commentsTableView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            commentsTableView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            commentsTableView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            commentsTableView.widthAnchor.constraint(equalTo: safeArea.widthAnchor),
            commentsTableView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),

            addCommentView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 600),
            addCommentView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            addCommentView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            addCommentView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),

            addCommentImage.topAnchor.constraint(equalTo: addCommentView.topAnchor, constant: 14),
            addCommentImage.leadingAnchor.constraint(equalTo: addCommentView.leadingAnchor, constant: 16),
            addCommentImage.heightAnchor.constraint(equalToConstant: 15),
            addCommentImage.widthAnchor.constraint(equalToConstant: 15),

            addCommentLabel.centerYAnchor.constraint(equalTo: addCommentImage.centerYAnchor),
            addCommentLabel.leadingAnchor.constraint(equalTo: addCommentImage.trailingAnchor, constant: 10),
            addCommentLabel.trailingAnchor.constraint(equalTo: addCommentView.trailingAnchor, constant: -190),
            addCommentLabel.bottomAnchor.constraint(equalTo: addCommentView.bottomAnchor, constant: -14)
        ])

        NSLayoutConstraint.activate([
            topSeparatorView.topAnchor.constraint(equalTo: detailPostView.topAnchor),
            topSeparatorView.leadingAnchor.constraint(equalTo: detailPostView.leadingAnchor, constant: 29),
            topSeparatorView.trailingAnchor.constraint(equalTo: detailPostView.trailingAnchor, constant: -29),
            topSeparatorView.heightAnchor.constraint(equalToConstant: 1),

            avatarImageView.topAnchor.constraint(equalTo: topSeparatorView.bottomAnchor, constant: 18),
            avatarImageView.leadingAnchor.constraint(equalTo: detailPostView.leadingAnchor, constant: 29),
            avatarImageView.heightAnchor.constraint(equalToConstant: 30),
            avatarImageView.widthAnchor.constraint(equalToConstant: 30),

            identifierLabel.topAnchor.constraint(equalTo: topSeparatorView.bottomAnchor, constant: 18),
            identifierLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 16),
            identifierLabel.trailingAnchor.constraint(equalTo: detailPostView.trailingAnchor, constant: -210),
            identifierLabel.bottomAnchor.constraint(equalTo: detailPostView.bottomAnchor, constant: -680),

            jobLabel.topAnchor.constraint(equalTo: identifierLabel.bottomAnchor, constant: 2),
            jobLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 16),
            jobLabel.trailingAnchor.constraint(equalTo: detailPostView.trailingAnchor, constant: -210),
            jobLabel.bottomAnchor.constraint(equalTo: detailPostView.bottomAnchor, constant: -670),

            postTextLabel.topAnchor.constraint(equalTo: jobLabel.bottomAnchor, constant: 15),
            postTextLabel.leadingAnchor.constraint(equalTo: detailPostView.leadingAnchor, constant: 16),
            postTextLabel.trailingAnchor.constraint(equalTo: detailPostView.trailingAnchor, constant: -16),
            postTextLabel.heightAnchor.constraint(lessThanOrEqualToConstant: 340),

            likeButton.topAnchor.constraint(equalTo: postTextLabel.bottomAnchor, constant: 16),
            likeButton.leadingAnchor.constraint(equalTo: detailPostView.leadingAnchor, constant: 17),
            likeButton.heightAnchor.constraint(equalToConstant: 22),
            likeButton.widthAnchor.constraint(equalToConstant: 22),

            likesLabel.topAnchor.constraint(equalTo: postTextLabel.bottomAnchor, constant: 16),
            likesLabel.leadingAnchor.constraint(equalTo: likeButton.trailingAnchor, constant: 5),
            likesLabel.trailingAnchor.constraint(equalTo: detailPostView.trailingAnchor, constant: -307),
            likesLabel.bottomAnchor.constraint(equalTo: separatorView.topAnchor, constant: -5),

            commentsButton.topAnchor.constraint(equalTo: postTextLabel.bottomAnchor, constant: 16),
            commentsButton.leadingAnchor.constraint(equalTo: likesLabel.trailingAnchor, constant: 24),
            commentsButton.heightAnchor.constraint(equalToConstant: 22),
            commentsButton.widthAnchor.constraint(equalToConstant: 22),

            commentsLabel.topAnchor.constraint(equalTo: postTextLabel.bottomAnchor, constant: 16),
            commentsLabel.leadingAnchor.constraint(equalTo: commentsButton.trailingAnchor, constant: 5),
            commentsLabel.trailingAnchor.constraint(equalTo: detailPostView.trailingAnchor, constant: -231),
            commentsLabel.bottomAnchor.constraint(equalTo: separatorView.topAnchor, constant: -5),

            bookmarkButton.topAnchor.constraint(equalTo: postTextLabel.bottomAnchor, constant: 16),
            bookmarkButton.leadingAnchor.constraint(equalTo: commentsLabel.trailingAnchor, constant: 183),
            bookmarkButton.heightAnchor.constraint(equalToConstant: 22),
            bookmarkButton.widthAnchor.constraint(equalToConstant: 22),

            separatorView.topAnchor.constraint(equalTo: bookmarkButton.bottomAnchor, constant: 17),
            separatorView.leadingAnchor.constraint(equalTo: detailPostView.leadingAnchor, constant: 29),
            separatorView.trailingAnchor.constraint(equalTo: detailPostView.trailingAnchor, constant: -29),
            separatorView.heightAnchor.constraint(equalToConstant: 1),

            tableViewTitle.topAnchor.constraint(equalTo: separatorView.bottomAnchor, constant: 15),
            tableViewTitle.leadingAnchor.constraint(equalTo: detailPostView.leadingAnchor, constant: 16),
            tableViewTitle.trailingAnchor.constraint(equalTo: detailPostView.trailingAnchor, constant: -200),
        ])
    }
}
