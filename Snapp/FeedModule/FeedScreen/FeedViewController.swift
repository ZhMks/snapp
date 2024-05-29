//
//  FeedViewController.swift
//  Snapp
//
//  Created by Максим Жуин on 06.04.2024.
//

import UIKit


final class FeedViewController: UIViewController {

    // MARK: -PROPERTIES

    var presenter: FeedPresenter!

    private lazy var headerView: UIView = {
        let headerView = UIView()
        headerView.translatesAutoresizingMaskIntoConstraints = false
        headerView.backgroundColor = .systemBackground
        return headerView
    }()

    private lazy var currentUserStorie: UIImageView = {
        let currentUserStorie = UIImageView()
        let image = UIImage(systemName: "checkmark")
        currentUserStorie.image = image
        currentUserStorie.translatesAutoresizingMaskIntoConstraints = false
        currentUserStorie.layer.cornerRadius = 12.0
        currentUserStorie.layer.borderWidth = 1.0
        currentUserStorie.layer.borderColor = UIColor.orange.cgColor
        currentUserStorie.backgroundColor = ColorCreator.shared.createTextColor()
        return currentUserStorie
    }()

    private lazy var storiesCollection: UICollectionView = {
        let flow = UICollectionViewFlowLayout()
        flow.scrollDirection = .horizontal
        let storiesCollection = UICollectionView(frame: .zero, collectionViewLayout: flow)
        storiesCollection.dataSource = self
        storiesCollection.delegate = self
        storiesCollection.translatesAutoresizingMaskIntoConstraints = false
        storiesCollection.backgroundColor = .systemBackground
        storiesCollection.register(FeedCollectionViewCell.self, forCellWithReuseIdentifier: FeedCollectionViewCell.identifier)
        return storiesCollection
    }()

    private lazy var feedTableView: UITableView = {
        let feedTableView = UITableView()
        feedTableView.translatesAutoresizingMaskIntoConstraints = false
        feedTableView.delegate = self
        feedTableView.dataSource = self
        feedTableView.backgroundColor = .systemGray5
        return feedTableView
    }()

    // MARK: -LIFECYCLE

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        presenter.addUserListener()
        presenter.fetchUserStorie()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        addSubviews()
        tuneTableView()
        layout()
        presenter.fetchPosts()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        presenter.removeListener()
    }

    // MARK: -FUNCS

    func tuneTableView() {
        feedTableView.register(PostTableCell.self, forCellReuseIdentifier: PostTableCell.identifier)
        feedTableView.rowHeight = UITableView.automaticDimension
        feedTableView.estimatedRowHeight = 44.0
        feedTableView.tableFooterView = UIView()
        feedTableView.separatorStyle = .none
        self.feedTableView.reloadData()
    }

    func tuneNavItem() {
        self.navigationItem.title = .localized(string: "Главная")
    }

    func user(forSection: Int) -> FirebaseUser? {
        guard let user = presenter.posts?.keys else {
            return nil
        }
        return Array(user)[forSection]
    }

}

// MARK: -OUTPUT PRESENTER
extension FeedViewController: FeedViewProtocol {

    func updateStorieView() {
        self.storiesCollection.reloadData()
    }
    
    func updateViewTable() {
        self.feedTableView.reloadData()
    }

    func showEmptyScreen() {
        print("SHOWFEEDEMPTYSCREEN")
    }
}

// MARK: -LAYOUT

extension FeedViewController {

    private func addSubviews() {
        view.addSubview(feedTableView)
        view.addSubview(currentUserStorie)
        view.addSubview(storiesCollection)
    }

    private func layout() {

        let safeArea = view.safeAreaLayoutGuide

        NSLayoutConstraint.activate([
            currentUserStorie.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 40),
            currentUserStorie.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 16),
            currentUserStorie.heightAnchor.constraint(equalToConstant: 69),
            currentUserStorie.widthAnchor.constraint(equalToConstant: 69),

            storiesCollection.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 20),
            storiesCollection.leadingAnchor.constraint(equalTo: currentUserStorie.trailingAnchor, constant: 16),
            storiesCollection.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            storiesCollection.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -590),

            feedTableView.topAnchor.constraint(equalTo: currentUserStorie.bottomAnchor, constant: 22),
            feedTableView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            feedTableView.trailingAnchor.constraint(equalTo: feedTableView.trailingAnchor),
            feedTableView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            feedTableView.widthAnchor.constraint(equalTo: safeArea.widthAnchor)
        ])

    }

}

// MARK: -COLLECTIONVIEWFLOWDELEGATE
extension FeedViewController: UICollectionViewDelegateFlowLayout {

}

// MARK: -COLLECTIONVIEWDATA
extension FeedViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let number = presenter.userStories?.count else { return 0 }
        return number
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
       guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FeedCollectionViewCell.identifier, for: indexPath) as? FeedCollectionViewCell else { return UICollectionViewCell() }
        guard let data = presenter.userStories?[indexPath.row] else { return  UICollectionViewCell() }
        cell.updateCell(image: data)
        return cell
    }
}

// MARK: -TABLEVIEWDELEGATE
extension FeedViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailPostVC = DetailPostViewController()
        guard let user = user(forSection: indexPath.section) else { return }
        guard let post = presenter.posts?[user]?[indexPath.row] else { return }
        if let image = user.image {
            let networkService = NetworkService()
            networkService.fetchImage(string: image) { [weak self] result in
                guard let self else { return }
                switch result {
                case .success(let success):
                    DispatchQueue.main.async { [weak self] in
                        guard let self else { return }
                        if let avatarImage = UIImage(data: success) {
                                let detailPostPresenter = DetailPostPresenter(view: detailPostVC, user: user, post: post, image: avatarImage, firestoreService: presenter.firestoreService)
                                    detailPostVC.presenter = detailPostPresenter
                                    detailPostPresenter.state = .feedMenu
                                    self.navigationController?.pushViewController(detailPostVC, animated: true)
                        }
                    }
                case .failure(_):
                    return
                }
            }
        }
    }

}

// MARK: -TABLEVIEWDATASOURCE
extension FeedViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        guard let number = presenter.posts?.count else { return 0 }
        return number
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let user = user(forSection: section) else { return 0 }
        guard let number = presenter.posts?[user]?.count else { return 0 }
        return number
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PostTableCell.identifier, for: indexPath) as? PostTableCell else { return UITableViewCell() }
        guard let user = user(forSection: indexPath.section) else { return UITableViewCell() }
        if let data = presenter.posts?[user]?[indexPath.row] {
            cell.updateView(post: data, user: user, date: data.date, firestoreService: presenter.firestoreService)
            cell.state = .feedCell
        }
        return cell
    }


}
