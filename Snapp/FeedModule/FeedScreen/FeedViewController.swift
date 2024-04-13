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
        let storiesCollection = UICollectionView(frame: .zero, collectionViewLayout: flow)
        storiesCollection.dataSource = self
        storiesCollection.delegate = self
        storiesCollection.translatesAutoresizingMaskIntoConstraints = false
        storiesCollection.backgroundColor = ColorCreator.shared.createTextColor()
        return storiesCollection
    }()

    private lazy var feedTableView: UITableView = {
        let feedTableView = UITableView()
        feedTableView.translatesAutoresizingMaskIntoConstraints = false
        feedTableView.delegate = self
        feedTableView.dataSource = self
        feedTableView.backgroundColor = ColorCreator.shared.createTextColor()
        return feedTableView
    }()

    private lazy var feedScrollView: UIScrollView = {
        let feedScrollView = UIScrollView()
        feedScrollView.translatesAutoresizingMaskIntoConstraints = false
        feedScrollView.backgroundColor = .red
        return feedScrollView
    }()

    // MARK: -LIFECYCLE

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        print("INSIDEFEEDVIEW USER: \(presenter.user)")
        print("InsideFEEDVEIW USERPOST: \(presenter.user)")
    }

    // MARK: -FUNCS


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
        view.addSubview(currentUserStorie)
        view.addSubview(storiesCollection)
        view.addSubview(feedScrollView)
        feedScrollView.addSubview(feedTableView)
    }

    private func layout() {
        let safeArea = view.safeAreaLayoutGuide

        NSLayoutConstraint.activate([
            currentUserStorie.topAnchor.constraint(equalTo: safeArea.topAnchor),
            currentUserStorie.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 16),
            currentUserStorie.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -299),
            currentUserStorie.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -563),

            storiesCollection.topAnchor.constraint(equalTo: safeArea.topAnchor),
            storiesCollection.leadingAnchor.constraint(equalTo: currentUserStorie.trailingAnchor, constant: 12),
            storiesCollection.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            storiesCollection.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -563),

            feedScrollView.topAnchor.constraint(equalTo: storiesCollection.bottomAnchor, constant: 22),
            feedScrollView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 16),
            feedScrollView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -15),
            feedScrollView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),

            feedTableView.topAnchor.constraint(equalTo: feedScrollView.topAnchor),
            feedTableView.leadingAnchor.constraint(equalTo: feedScrollView.leadingAnchor),
            feedTableView.trailingAnchor.constraint(equalTo: feedScrollView.trailingAnchor),
            feedTableView.bottomAnchor.constraint(equalTo: feedScrollView.bottomAnchor),
            feedTableView.widthAnchor.constraint(equalTo: feedScrollView.widthAnchor)
        ])
    }

}

// MARK: -COLLECTIONVIEWFLOWDELEGATE
extension FeedViewController: UICollectionViewDelegateFlowLayout {

}

// MARK: -COLLECTIONVIEWDATA
extension FeedViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        4
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        cell.backgroundColor = .blue
        return cell
    }
}

// MARK: -TABLEVIEWDELEGATE
extension FeedViewController: UITableViewDelegate {

}

// MARK: -TABLEVIEWDATASOURCE
extension FeedViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableCell", for: indexPath)
        cell.backgroundColor = .blue
        return cell
    }
    

}
