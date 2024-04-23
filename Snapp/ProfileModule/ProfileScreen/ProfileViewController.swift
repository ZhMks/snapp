//
//  ProfileViewController.swift
//  Snapp
//
//  Created by Максим Жуин on 08.04.2024.
//

import UIKit

class ProfileViewController: UIViewController {
// MARK: -PROPERTIES
    var presenter: ProfilePresenter!

    private lazy var createPostButton: UIButton = {
        let createPost = UIButton(type: .system)
        createPost.backgroundColor = ColorCreator.shared.createButtonColor()
        createPost.setTitle(.localized(string: "Подтвердить"), for: .normal)
        createPost.setTitleColor(.systemBackground, for: .normal)
        createPost.layer.cornerRadius = 10.0
        createPost.titleLabel?.font = UIFont(name: "Inter-Medium", size: 12)
        createPost.translatesAutoresizingMaskIntoConstraints = false
        createPost.addTarget(self, action: #selector(createPostButtonTapped), for: .touchUpInside)
        return createPost
    }()

// MARK: -LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        tuneNavItem()
        addSubviews()
        layout()

        presenter.posts?.forEach({ postmodel in
            let eachPostService = EachPostCoreDataModelService(mainModel: postmodel)
            eachPostService.modelArray?.forEach({ model in
                print(model.text, model.postMainModel)
            })
        })
    }
    
// MARK: -FUNCS
    @objc func createPostButtonTapped() {
        let text = "TestPostText"
        let image = UIImage(systemName: "checkmark")
        presenter.createPost(text: text, image: image!) { result in
            switch result {
            case .success(let postMainModel):
                print()
            case .failure(let failure):
                print(failure.localizedDescription)
            }
        }
    }

}

// MARK: -OUTPUT PRESENTER
extension ProfileViewController: ProfileViewProtocol {
    func showErrorAler(error: String) {
        print("ShowAlert")
    }
}


// MARK: -LAYOUT
extension ProfileViewController {
    func tuneNavItem() {
        let settingsButton = UIBarButtonItem(image: UIImage(systemName: "line.3.horizontal"),
                                             style: .plain,
                                             target: self,
                                             action: #selector(showSettingsVC))
        settingsButton.tintColor = .systemYellow
        self.navigationItem.rightBarButtonItem = settingsButton
    }

    @objc func showSettingsVC() {
//        let settingsVC = SettingsViewController()
//        let settingsPresenter = SettingPresenter(view: settingsVC, user: presenter.firebaseUser, firestoreService: presenter.firestoreService)
//        settingsVC.presenter = settingsPresenter
//        navigationController?.present(settingsVC, animated: true)
    }

    func addSubviews() {
        view.addSubview(createPostButton)
    }

    func layout() {
        let safeArea = view.safeAreaLayoutGuide

        NSLayoutConstraint.activate([
            createPostButton.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            createPostButton.centerYAnchor.constraint(equalTo: safeArea.centerYAnchor)
        ])
    }
}
