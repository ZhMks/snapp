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

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        addSubviews()
        tuneTableView()
        layout()
    }

    // MARK: -FUNCS


    @objc func createStorie() {
       
    }

    @objc func createSub() {

    }

    func tuneTableView() {
        feedTableView.register(PostTableCell.self, forCellReuseIdentifier: PostTableCell.identifier)
        feedTableView.rowHeight = UITableView.automaticDimension
        feedTableView.estimatedRowHeight = 44.0
        feedTableView.tableFooterView = UIView()
        feedTableView.separatorStyle = .none
        self.feedTableView.reloadData()
    }


}

// MARK: -OUTPUT PRESENTER
extension FeedViewController: FeedViewProtocol {
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
            storiesCollection.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -550),

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
//        guard let number = presenter.posts?.count else { return 0 }
//        return number
        6
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
       guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FeedCollectionViewCell.identifier, for: indexPath) as? FeedCollectionViewCell else { return UICollectionViewCell() }
        cell.backgroundColor = .blue
      //  guard let data = presenter.posts?[indexPath.section] else { return  UICollectionViewCell() }
        return cell
    }
}

// MARK: -TABLEVIEWDELEGATE
extension FeedViewController: UITableViewDelegate {

}

// MARK: -TABLEVIEWDATASOURCE
extension FeedViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //presenter.user.subscribers
        4
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PostTableCell.identifier, for: indexPath) as? PostTableCell else { return UITableViewCell() }
        guard let data = presenter.posts?[indexPath.section][indexPath.row].postsArray[indexPath.row] else { return UITableViewCell() }
        guard let date = presenter.posts?[indexPath.section][indexPath.row].date else { return UITableViewCell() }
        cell.backgroundColor = .systemYellow
        return cell
    }


}
