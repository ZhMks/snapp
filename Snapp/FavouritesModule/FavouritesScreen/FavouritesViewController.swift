//
//  FavouritesViewController.swift
//  Snapp
//
//  Created by Максим Жуин on 08.04.2024.
//

import UIKit

class FavouritesViewController: UIViewController {

    // MARK: - Properties
    private lazy var favouritesTableView: UITableView = {
        let favouritesTableView = UITableView()
        favouritesTableView.translatesAutoresizingMaskIntoConstraints = false
        favouritesTableView.delegate = self
        favouritesTableView.dataSource = self
        favouritesTableView.register(FavouriteTableViewCell.self, forCellReuseIdentifier: FavouriteTableViewCell.identifier)
        return favouritesTableView
    }()

    var presenter: FavouritesPresenter!

    // MARK: - Lifecycle

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.addSnapshotListenerToPost()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        addSubview()
        layout()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        presenter.removeListener()
    }

}
// MARK: - Presenter Output

extension FavouritesViewController: FavouritesViewProtocol {
    func updateData() {
        favouritesTableView.reloadData()
    }
}

// MARK: - TableView DataSource
extension FavouritesViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let number = presenter.posts?.count else { return 0 }
        return number
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FavouriteTableViewCell.identifier, for: indexPath) as? FavouriteTableViewCell else { return UITableViewCell() }
        guard let data = presenter.posts?[indexPath.row] else { return UITableViewCell() }
        cell.updateView(post: data , user: presenter.user, date: data.date, firestoreService: presenter.firestoreService)
        return cell
    }
    

}

// MARK: - TableView Delegate

extension FavouritesViewController: UITableViewDelegate {

}

// MARK: - Layout

extension FavouritesViewController {
    func addSubview() {
        view.addSubview(favouritesTableView)
    }

    func layout() {
        let safeArea = view.safeAreaLayoutGuide
        favouritesTableView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            favouritesTableView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            favouritesTableView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            favouritesTableView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            favouritesTableView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor)
        ])
    }
}
