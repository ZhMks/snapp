//
//  FeedViewController.swift
//  Snapp
//
//  Created by Максим Жуин on 06.04.2024.
//

import UIKit


final class FeedViewController: UIViewController {

    // MARK: -Properties

    var presenter: FeedPresenter!

    private lazy var headerView: UIView = {
        let headerView = UIView()
        headerView.translatesAutoresizingMaskIntoConstraints = false
        headerView.backgroundColor = .systemBackground
        return headerView
    }()

    private lazy var currentUserStorie: UIImageView = {
        let currentUserStorie = UIImageView()
        currentUserStorie.translatesAutoresizingMaskIntoConstraints = false
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

    // MARK: -Lifecycle

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        presenter.addUserListener()
        presenter.fetchSubscribersStorie()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        addSubviews()
        tuneTableView()
        layout()
        presenter.fetchAvatarImage()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        presenter.removeListener()
    }

    // MARK: -Funcs

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

// MARK: -Presenter Output
extension FeedViewController: FeedViewProtocol {
    func showError(descr: String) {
        print(descr)
    }


    func showMenuForFeed(post: EachPost) {
        let feedMenu = MenuForFeedViewController()
        let feedPresenter = MenuForFeedPresenter(view: feedMenu, user: self.presenter.mainUser, post: post, mainUserID: self.presenter.mainUserID)
        feedMenu.presenter = feedPresenter
        feedMenu.modalPresentationStyle = .formSheet

        if let sheet = feedMenu.sheetPresentationController {
            let customHeight = UISheetPresentationController.Detent.custom(identifier: .init("customHeight")) { context in
                return 300
            }
            sheet.detents = [customHeight]
            sheet.largestUndimmedDetentIdentifier = .some(customHeight.identifier)
        }
        self.navigationController?.present(feedMenu, animated: true)
    }

    func updateAvatarImage(image: UIImage) {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            self.currentUserStorie.image = image
            self.currentUserStorie.clipsToBounds = true
            self.currentUserStorie.layer.cornerRadius = self.currentUserStorie.frame.size.width / 2
        }
    }

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
            storiesCollection.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -560),

            feedTableView.topAnchor.constraint(equalTo: currentUserStorie.bottomAnchor, constant: 22),
            feedTableView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            feedTableView.trailingAnchor.constraint(equalTo: feedTableView.trailingAnchor),
            feedTableView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            feedTableView.widthAnchor.constraint(equalTo: safeArea.widthAnchor)
        ])

    }

}

// MARK: -CollectionView Delegate
extension FeedViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: 80, height: 80)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let data = presenter.userStories else { return }
        let user = Array(data.keys)[indexPath.row]
        let detailStorieScreen = DetailStorieViewController()
        let detailStoriePresenter = DetailStoriePresenter(view: detailStorieScreen, mainUser: user)
        detailStorieScreen.presenter = detailStoriePresenter
        self.navigationController?.pushViewController(detailStorieScreen, animated: true)
    }
}

// MARK: -CollectionView DataSource
extension FeedViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let number = presenter.userStories?.keys.count else { return 0 }
        return number
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FeedCollectionViewCell.identifier, for: indexPath) as? FeedCollectionViewCell else { return UICollectionViewCell() }
        guard let data = presenter.userStories else { return  UICollectionViewCell() }
        let key = Array(data.keys)[indexPath.row]
        guard let image = data[key] else { return UICollectionViewCell() }
        cell.updateCell(image: image)
        return cell
    }
}

// MARK: -TableView Delegate
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
                case .success(let avatarImage):
                    let detailPostPresenter = DetailPostPresenter(view: detailPostVC, user: user, mainUserID: self.presenter.mainUserID, post: post, avatarImage: avatarImage)
                    detailPostVC.presenter = detailPostPresenter
                    detailPostVC.postMenuState = .feedPost
                    DispatchQueue.main.async { [weak self] in
                        self?.navigationController?.pushViewController(detailPostVC, animated: true)
                    }
                case .failure(_):
                    return
                }
            }
        }
    }

}

// MARK: -TableView DataSource
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
            cell.updateView(post: data, user: user, state: .feedState, mainUserID: self.presenter.mainUserID)
        }

        cell.showMenuForFeed = { [weak self] post in
            guard let self else { return }
            presenter.showMenuForFeed(post: post)
        }

        return cell
    }


}
