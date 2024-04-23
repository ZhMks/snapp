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
        storiesCollection.register(FeedCollectionViewCell.self, forCellWithReuseIdentifier: FeedCollectionViewCell.identifier)
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

    private lazy var createPostButton: UIButton = {
        let createPost = UIButton(type: .system)
        createPost.backgroundColor = ColorCreator.shared.createButtonColor()
        createPost.setTitle(.localized(string: "Подтвердить"), for: .normal)
        createPost.setTitleColor(.systemBackground, for: .normal)
        createPost.layer.cornerRadius = 10.0
        createPost.titleLabel?.font = UIFont(name: "Inter-Medium", size: 12)
        createPost.translatesAutoresizingMaskIntoConstraints = false
        createPost.addTarget(self, action: #selector(createSub), for: .touchUpInside)
        return createPost
    }()


    private lazy var createStorieButton: UIButton = {
        let createPost = UIButton(type: .system)
        createPost.backgroundColor = ColorCreator.shared.createButtonColor()
        createPost.setTitle(.localized(string: "Storie"), for: .normal)
        createPost.setTitleColor(.systemBackground, for: .normal)
        createPost.layer.cornerRadius = 10.0
        createPost.titleLabel?.font = UIFont(name: "Inter-Medium", size: 12)
        createPost.translatesAutoresizingMaskIntoConstraints = false
        createPost.addTarget(self, action: #selector(createStorie), for: .touchUpInside)
        return createPost
    }()

    // MARK: -LIFECYCLE

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        addSubviews()
        layout()
    }

    // MARK: -FUNCS


    @objc func createStorie() {
        let image = UIImage(named: "f")
    }

    @objc func createSub() {
        let string = "PkMeY82d1PXWs8yoPcRebAB764x2"
        presenter.saveSubscriber(id: string) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let success):
                print(success.name, success.job)
            case .failure(let failure):
                print(failure.localizedDescription)
            }
        }
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
//        view.addSubview(currentUserStorie)
//        view.addSubview(storiesCollection)
//        view.addSubview(feedScrollView)
        view.addSubview(createPostButton)
        view.addSubview(createStorieButton)
//        feedScrollView.addSubview(feedTableView)
    }

    private func layout() {
        let safeArea = view.safeAreaLayoutGuide

        NSLayoutConstraint.activate([
//            currentUserStorie.topAnchor.constraint(equalTo: safeArea.topAnchor),
//            currentUserStorie.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 16),
//            currentUserStorie.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -299),
//            currentUserStorie.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -563),
//
//            storiesCollection.topAnchor.constraint(equalTo: safeArea.topAnchor),
//            storiesCollection.leadingAnchor.constraint(equalTo: currentUserStorie.trailingAnchor, constant: 12),
//            storiesCollection.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
//            storiesCollection.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -563),
//
//            feedScrollView.topAnchor.constraint(equalTo: storiesCollection.bottomAnchor, constant: 22),
//            feedScrollView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 16),
//            feedScrollView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -15),
//            feedScrollView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
//
//            feedTableView.topAnchor.constraint(equalTo: feedScrollView.topAnchor),
//            feedTableView.leadingAnchor.constraint(equalTo: feedScrollView.leadingAnchor),
//            feedTableView.trailingAnchor.constraint(equalTo: feedScrollView.trailingAnchor),
//            feedTableView.bottomAnchor.constraint(equalTo: feedScrollView.bottomAnchor),
//            feedTableView.widthAnchor.constraint(equalTo: feedScrollView.widthAnchor)

            createPostButton.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            createPostButton.centerYAnchor.constraint(equalTo: safeArea.centerYAnchor),

            createStorieButton.topAnchor.constraint(equalTo: createPostButton.bottomAnchor, constant: 30),
            createStorieButton.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 150),
            createStorieButton.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -140),
            createStorieButton.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -102)
        ])
    }

}

// MARK: -COLLECTIONVIEWFLOWDELEGATE
extension FeedViewController: UICollectionViewDelegateFlowLayout {

}

// MARK: -COLLECTIONVIEWDATA
extension FeedViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let number = presenter.posts?.count else { return 0 }
        return number
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
       guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FeedCollectionViewCell.identifier, for: indexPath) as? FeedCollectionViewCell else { return UICollectionViewCell() }
        cell.backgroundColor = .blue
        guard let data = presenter.posts?[indexPath.section] else { return  UICollectionViewCell() }

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
        0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableCell", for: indexPath)
        cell.backgroundColor = .blue
        return cell
    }


}
