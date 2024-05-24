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

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        addSubviews()
        layout()
        presenter.getAllUsers()
    }


    //MARK: -FUNCS
}


//MARK: -OUTPUTPRESENTER

extension SearchViewController: SearchViewProtocol {

    func updateTableView() {
        allUsersTable.reloadData()
    }
    
    func goToNextVC(user: FirebaseUser, userID: String) {
        let detailVC = DetailUserViewController()
        let detailPresenter = DetailPresenter(view: detailVC, user: user, userID: userID, firestoreService: presenter.firestoreService)
        detailVC.presenter = detailPresenter
        navigationController?.pushViewController(detailVC, animated: true)
    }

    func showErrorAlert(error: String) {
        switch error {
        case  "Ошибка сервера":
            let alert = UIAlertController(title: .localized(string: "Ошибка"),
                                          message: .localized(string: "Не удалось загрузить пользователей"),
                                          preferredStyle: .alert)
            let action = UIAlertAction(title: .localized(string: "Отмена"), style: .cancel)
            alert.addAction(action)
            navigationController?.present(alert, animated: true)
        case "Ошибка декодирования":
            let alert = UIAlertController(title: .localized(string: "Ошибка"),
                                          message: .localized(string: "Не удалось загрузить пользователей"),
                                          preferredStyle: .alert)
            let action = UIAlertAction(title: .localized(string: "Отмена"), style: .cancel)
            alert.addAction(action)
            navigationController?.present(alert, animated: true)
        case "Посты отсутстуют":
            let alert = UIAlertController(title: .localized(string: "Ошибка"),
                                          message: .localized(string: "Не удалось загрузить пользователей"),
                                          preferredStyle: .alert)
            let action = UIAlertAction(title: .localized(string: "Отмена"), style: .cancel)
            alert.addAction(action)
            navigationController?.present(alert, animated: true)
        default: return
        }
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
        guard let avatarImage = dataSource.image else { return UITableViewCell() }
        cell.updateCell(image: avatarImage, name: dataSource.name, surname: dataSource.surname, job: dataSource.job)
        return cell
    }


}

// MARK: -TABLEVIEWDELEGATE
extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = presenter.usersArray[indexPath.row]
        guard let documentID = user.documentID else { return }
        presenter.showNextVC(user: user, userID: documentID)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
