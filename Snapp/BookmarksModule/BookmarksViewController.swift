//
//  BookmarksViewController.swift
//  Snapp
//
//  Created by Максим Жуин on 15.06.2024.
//

import UIKit

class BookmarksViewController: UIViewController {

    // MARK: - Properties
    var presenter: BookmarksPresenter!

    private lazy var bookmarksTableView: UITableView = {
        let bookmarksTableView = UITableView()
        bookmarksTableView.translatesAutoresizingMaskIntoConstraints = false
        bookmarksTableView.delegate = self
        bookmarksTableView.dataSource = self
        bookmarksTableView.register(PostTableCell.self, forCellReuseIdentifier: PostTableCell.identifier)
        return bookmarksTableView
    }()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}

// MARK: - Presenter Output

extension BookmarksViewController: BookmarksViewProtocol {
    func showError() {
        print("Error in Bookmarks Posts Fetch")
    }
}


// MARK: - TableView DataSource

extension BookmarksViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let number = presenter.posts?.count else { return 0 }
        return number
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PostTableCell.identifier, for: indexPath) as? PostTableCell else { return UITableViewCell() }
        guard let data = presenter.posts?[indexPath.row] else { return UITableViewCell() }
        cell.updateView(post: data, user: presenter.user, date: data.date, firestoreService: presenter.firestoreService, state: .profileState)
        return cell
    }

}

// MARK: - TableView Delegate

extension BookmarksViewController: UITableViewDelegate {

}

// MARK: - Layout

extension BookmarksViewController {

}
