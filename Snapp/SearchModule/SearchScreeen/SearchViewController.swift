//
//  SearchViewController.swift
//  Snapp
//
//  Created by Максим Жуин on 22.04.2024.
//

import UIKit

class SearchViewController: UIViewController {


    // MARK: -PROPERTIES
    private lazy var searchField: UITextField = {
        let searchField = UITextField()
        searchField.translatesAutoresizingMaskIntoConstraints = false
        searchField.borderStyle = .roundedRect
        return searchField
    }()

    private lazy var allUsersTable: UITableView = {
        let allUsersTable = UITableView(frame: .zero, style: .insetGrouped)
        allUsersTable.translatesAutoresizingMaskIntoConstraints = false
        allUsersTable.delegate = self
        allUsersTable.dataSource = self
        allUsersTable.register(SearchTableViewCell.self, forCellReuseIdentifier: SearchTableViewCell.identifier)
        return allUsersTable
    }()

    var presenter: SearchPresenter!

    //MARK: -LIFECYCLE

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        presenter.getAllUsers()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        addSubviews()
        layout()
        performUpdate()
    }


    //MARK: -FUNCS
    func performUpdate() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
            guard let self else { return }
            allUsersTable.reloadData()
        }
    }
}


//MARK: -OUTPUTPRESENTER

extension SearchViewController: SearchViewProtocol {
    func showErrorAlert() {
        let alert = UIAlertController(title: .localized(string: "Ошибка"),
                                      message: .localized(string: "Не удалось загрузить пользователей"),
                                      preferredStyle: .alert)
        let action = UIAlertAction(title: .localized(string: "Отмена"), style: .cancel)
        alert.addAction(action)
        navigationController?.present(alert, animated: true)
    }
}


//MARK: -LAYOUT

extension SearchViewController {

    private func addSubviews() {
        view.addSubview(searchField)
        view.addSubview(allUsersTable)
    }

    private func layout() {
        let safeArea = view.safeAreaLayoutGuide

        NSLayoutConstraint.activate([
            searchField.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 20),
            searchField.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 80),
            searchField.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -80),
            searchField.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -580),

            allUsersTable.topAnchor.constraint(equalTo: searchField.bottomAnchor, constant: 15),
            allUsersTable.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 25),
            allUsersTable.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -20),
            allUsersTable.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -15)
        ])
    }
}

// MARK: -TABLEVIEWDATASOURCE
extension SearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter.usersArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchTableViewCell.identifier, for: indexPath) as? SearchTableViewCell else { return UITableViewCell() }
        guard let dataSource = presenter?.usersArray[indexPath.row] else { return UITableViewCell() }
        cell.updateCell(image: dataSource.image, name: dataSource.name, surname: dataSource.surname, job: dataSource.job)
        return cell
    }


}

// MARK: -TABLEVIEWDELEGATE
extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = presenter.usersArray[indexPath.row]
        self.presenter.fetchPostsFor(user: user.identifier)
        let detailUserController = DetailUserViewController()
        let detailPresenter = DetailPresenter(view: detailUserController, user: user, eachPosts: presenter.posts)
        detailUserController.presenter = detailPresenter
        navigationController?.pushViewController(detailUserController, animated: true)
    }
}
