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
        view.backgroundColor = .systemBackground
        addSubviews()
        layoutSubviews()
        presenter.fetchBookmarkedPosts()
        tuneNavItems()
    }

// MARK: - Funcs

    @objc func dismissViewController() {
        self.navigationController?.popViewController(animated: true)
    }
    
    private func tuneNavItems() {

        let customView = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: 25))

        let leftArrowButton = UIButton(type: .system)
        leftArrowButton.frame = CGRect(x: 0, y: 0, width: 25, height: 25)
        leftArrowButton.setBackgroundImage(UIImage(systemName: "arrow.left"), for: .normal)
        leftArrowButton.tintColor = .systemOrange
        leftArrowButton.addTarget(self, action: #selector(dismissViewController), for: .touchUpInside)
        customView.addSubview(leftArrowButton)

        let leftButton = UIBarButtonItem(customView: customView)
        self.navigationItem.leftBarButtonItem = leftButton

    }

}

// MARK: - Presenter Output

extension BookmarksViewController: BookmarksViewProtocol {
    func showError() {
        print("Error")
    }
    

    func showError(error: String) {
        print(error)
    }
    

    func updateTableView() {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            addSubviews()
            layoutSubviews()
            bookmarksTableView.reloadData()
        }
    }

}


// MARK: - TableView DataSource

extension BookmarksViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let number = presenter.posts?.count else { return 0 }
        return number
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: BookmarkedPostCell.identifier, for: indexPath) as? BookmarkedPostCell else { return UITableViewCell() }
        guard let data = presenter.posts?[indexPath.row] else { return UITableViewCell() }
        cell.updateView(post: data, user: presenter.user, state: .profileState, mainUserID: self.presenter.mainUserID)
        return cell
    }

}

// MARK: - TableView Delegate

extension BookmarksViewController: UITableViewDelegate {

}

// MARK: - Layout

extension BookmarksViewController {
    private func addSubviews() {
        view.addSubview(bookmarksTableView)
    }

    private func layoutSubviews() {
        let safeArea = view.safeAreaLayoutGuide

        NSLayoutConstraint.activate([
            bookmarksTableView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            bookmarksTableView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            bookmarksTableView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            bookmarksTableView.widthAnchor.constraint(equalTo: safeArea.widthAnchor),
            bookmarksTableView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor)
        ])
    }
}
