//
//  ProfileChangeViewController.swift
//  Snapp
//
//  Created by Максим Жуин on 08.04.2024.
//

import UIKit

class ProfileChangeViewController: UIViewController {

    //MARK: -Properties

    override var prefersStatusBarHidden: Bool {
        return true
    }

    var presenter: ProfileChangePresenter!

    private lazy var mainContentView: UIView = {
        let mainContentView = UIView()
        mainContentView.translatesAutoresizingMaskIntoConstraints = false
        mainContentView.backgroundColor = ColorCreator.shared.createPostBackgroundColor()
        return mainContentView
    }()

    private lazy var closeButton: UIButton = {
        let closeButton = UIButton(type: .system)
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        closeButton.setBackgroundImage(UIImage(systemName: "xmark"), for: .normal)
        closeButton.tintColor = .systemOrange
        closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        return closeButton
    }()

    private lazy var profileLabel: UILabel = {
        let profileLabel = UILabel()
        profileLabel.translatesAutoresizingMaskIntoConstraints = false
        profileLabel.text = .localized(string: "\(presenter.user.name)" + " \(presenter.user.surname)")
        profileLabel.textColor = ColorCreator.shared.createTextColor()
        profileLabel.font = UIFont(name: "Inter-Medium", size: 18)
        return profileLabel
    }()

    private lazy var separatorView: UIView = {
        let separatorView = UIView()
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        separatorView.backgroundColor = .systemGray2
        return separatorView
    }()

    private lazy var mainInformationButton: UIButton = {
        let mainInformationButton = UIButton(type: .system)
        mainInformationButton.translatesAutoresizingMaskIntoConstraints = false
        mainInformationButton.setTitle(.localized(string: "Основная информация"), for: .normal)
        mainInformationButton.setTitleColor(ColorCreator.shared.createTextColor(), for: .normal)
        mainInformationButton.contentHorizontalAlignment = .left
        mainInformationButton.addTarget(self, action: #selector(showDetailDataChangeScreen), for: .touchUpInside)
        return mainInformationButton
    }()

    private lazy var contactsButton: UIButton = {
        let contactsButton = UIButton(type: .system)
        contactsButton.translatesAutoresizingMaskIntoConstraints = false
        contactsButton.setTitle(.localized(string: "Контакты"), for: .normal)
        contactsButton.setTitleColor(ColorCreator.shared.createTextColor(), for: .normal)
        contactsButton.contentHorizontalAlignment = .left
        contactsButton.addTarget(self, action: #selector(showContactChangeScreen), for: .touchUpInside)
        return contactsButton
    }()

    private lazy var interestsButton: UIButton = {
        let interestsButton = UIButton(type: .system)
        interestsButton.translatesAutoresizingMaskIntoConstraints = false
        interestsButton.setTitle(.localized(string: "Интересы"), for: .normal)
        interestsButton.setTitleColor(ColorCreator.shared.createTextColor(), for: .normal)
        interestsButton.contentHorizontalAlignment = .left
        interestsButton.addTarget(self, action: #selector(showInterestChangeScreen), for: .touchUpInside)
        return interestsButton
    }()

    private lazy var educationButton: UIButton = {
        let educationButton = UIButton(type: .system)
        educationButton.translatesAutoresizingMaskIntoConstraints = false
        educationButton.setTitle(.localized(string: "Образование"), for: .normal)
        educationButton.setTitleColor(ColorCreator.shared.createTextColor(), for: .normal)
        educationButton.contentHorizontalAlignment = .left
        educationButton.addTarget(self, action: #selector(showEducationChangeScreen), for: .touchUpInside)
        return educationButton
    }()

    private lazy var careerButton: UIButton = {
        let careerButton = UIButton(type: .system)
        careerButton.translatesAutoresizingMaskIntoConstraints = false
        careerButton.setTitle(.localized(string: "Карьера"), for: .normal)
        careerButton.setTitleColor(ColorCreator.shared.createTextColor(), for: .normal)
        careerButton.contentHorizontalAlignment = .left
        careerButton.addTarget(self, action: #selector(showCareerChangeScreen), for: .touchUpInside)
        return careerButton
    }()

    //MARK: -Lifecycle

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(fetchUserIfNeeded), name: Notification.Name("DataChanged"), object: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        addSubviews()
        layout()
        view.backgroundColor = ColorCreator.shared.createBackgroundColorWithAlpah(alpha: 0.5)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
        navigationController?.navigationBar.isHidden = false
    }


    // MARK: -Funcs

    @objc func closeButtonTapped() {
        dismiss(animated: true)
    }

    @objc func showDetailDataChangeScreen() {
        presenter.goToDetailDataChangeScreen()
    }

    @objc func showContactChangeScreen() {
        presenter.goToContactsChangeScreen()
    }

    @objc func showInterestChangeScreen() {
        presenter.goToInterestsChangeScreen()
    }

    @objc func showEducationChangeScreen() {
        presenter.goToEducationChangeScreen()
    }

    @objc func showCareerChangeScreen() {
        presenter.goToCareerChangeScreen()
    }

    @objc func fetchUserIfNeeded() {
        presenter.getUserData()
    }

}


// MARK: -Presenter Output
extension ProfileChangeViewController: ProfileChangeViewProtocol {

    func showError(descr: String) {
        let uialertController = UIAlertController(title: .localized(string: "Ошибка"), message: .localized(string: descr), preferredStyle: .actionSheet)
        let alertAction = UIAlertAction(title: .localized(string: "Ошибка"), style: .cancel)
        uialertController.addAction(alertAction)
        self.navigationController?.present(uialertController, animated: true)
    }
    
    func presentDataChangeScreen() {
        let datachangeViewController = DataChangeViewController()
        let navigationController = UINavigationController(rootViewController: datachangeViewController)
        let datachangePresenter = DataChangePresenter(view: datachangeViewController,
                                                      mainUserID: self.presenter.mainUserID,
                                                      state: .mainInformation)
        datachangeViewController.presenter = datachangePresenter
        navigationController.modalPresentationStyle = .overCurrentContext
        present(navigationController, animated: true)
    }
    
    func presentContactsChangeScreen() {
        let dataChangeViewController = DataChangeViewController()
        let navigationController = UINavigationController(rootViewController: dataChangeViewController)
        let dataChangePresenter = DataChangePresenter(view: dataChangeViewController,
                                                      mainUserID: self.presenter.mainUserID,
                                                      state: .contacts)
        dataChangeViewController.presenter = dataChangePresenter
        navigationController.modalPresentationStyle = .overCurrentContext
        present(navigationController, animated: true)
    }
    
    func presentInterestChangeScreen() {
        let dataChangeViewController = DataChangeViewController()
        let navigationController = UINavigationController(rootViewController: dataChangeViewController)
        let dataChangePresenter = DataChangePresenter(view: dataChangeViewController,
                                                      mainUserID: self.presenter.mainUserID,
                                                      state: .interests)
        dataChangeViewController.presenter = dataChangePresenter
        navigationController.modalPresentationStyle = .overCurrentContext
        present(navigationController, animated: true)
    }
    
    func presentEducationChangeScreen() {
        let dataChangeViewController = DataChangeViewController()
        let navigationController = UINavigationController(rootViewController: dataChangeViewController)
        let dataChangePresenter = DataChangePresenter(view: dataChangeViewController,
                                                      mainUserID: self.presenter.mainUserID,
                                                      state: .education)
        dataChangeViewController.presenter = dataChangePresenter
        navigationController.modalPresentationStyle = .overCurrentContext
        present(navigationController, animated: true)
    }
    
    func presentCareerChangeScreen() {
        let dataChangeViewController = DataChangeViewController()
        let navigationController = UINavigationController(rootViewController: dataChangeViewController)
        let dataChangePresenter = DataChangePresenter(view: dataChangeViewController,
                                                      mainUserID: self.presenter.mainUserID,
                                                      state: .career)
        dataChangeViewController.presenter = dataChangePresenter
        navigationController.modalPresentationStyle = .overCurrentContext
        present(navigationController, animated: true)
    }
    

}


//MARK: -Layout
extension ProfileChangeViewController {

    func addSubviews() {
        view.addSubview(mainContentView)
        mainContentView.addSubview(closeButton)
        mainContentView.addSubview(profileLabel)
        mainContentView.addSubview(separatorView)
        mainContentView.addSubview(mainInformationButton)
        mainContentView.addSubview(contactsButton)
        mainContentView.addSubview(interestsButton)
        mainContentView.addSubview(educationButton)
        mainContentView.addSubview(careerButton)
    }

    func layout() {
        let safeArea = view.safeAreaLayoutGuide

        NSLayoutConstraint.activate([
            
            mainContentView.topAnchor.constraint(equalTo: view.topAnchor),
            mainContentView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 62),
            mainContentView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            mainContentView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            closeButton.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 15),
            closeButton.leadingAnchor.constraint(equalTo: mainContentView.leadingAnchor, constant: 30),
            closeButton.heightAnchor.constraint(equalToConstant: 35),
            closeButton.widthAnchor.constraint(equalToConstant: 35),

            profileLabel.topAnchor.constraint(equalTo: closeButton.bottomAnchor, constant: 25),
            profileLabel.leadingAnchor.constraint(equalTo: mainContentView.leadingAnchor, constant: 30),
            profileLabel.trailingAnchor.constraint(equalTo: mainContentView.trailingAnchor, constant: -101),
            profileLabel.heightAnchor.constraint(equalToConstant: 22),

            separatorView.topAnchor.constraint(equalTo: profileLabel.bottomAnchor, constant: 18),
            separatorView.leadingAnchor.constraint(equalTo: mainContentView.leadingAnchor, constant: 30),
            separatorView.trailingAnchor.constraint(equalTo: mainContentView.trailingAnchor, constant: -30),
            separatorView.heightAnchor.constraint(equalToConstant: 1),

            mainInformationButton.topAnchor.constraint(equalTo: separatorView.bottomAnchor, constant: 15),
            mainInformationButton.leadingAnchor.constraint(equalTo: mainContentView.leadingAnchor, constant: 14),
            mainInformationButton.trailingAnchor.constraint(equalTo: mainContentView.trailingAnchor, constant: -110),
            mainInformationButton.heightAnchor.constraint(equalToConstant: 22),

            contactsButton.topAnchor.constraint(equalTo: mainInformationButton.bottomAnchor, constant: 18),
            contactsButton.leadingAnchor.constraint(equalTo: mainContentView.leadingAnchor, constant: 14),
            contactsButton.trailingAnchor.constraint(equalTo: mainContentView.trailingAnchor, constant: -110),
            contactsButton.heightAnchor.constraint(equalToConstant: 22),

            interestsButton.topAnchor.constraint(equalTo: contactsButton.bottomAnchor, constant: 18),
            interestsButton.leadingAnchor.constraint(equalTo: mainContentView.leadingAnchor, constant: 14),
            interestsButton.trailingAnchor.constraint(equalTo: mainContentView.trailingAnchor, constant: -110),
            interestsButton.heightAnchor.constraint(equalToConstant: 22),

            educationButton.topAnchor.constraint(equalTo: interestsButton.bottomAnchor, constant: 18),
            educationButton.leadingAnchor.constraint(equalTo: mainContentView.leadingAnchor, constant: 14),
            educationButton.trailingAnchor.constraint(equalTo: mainContentView.trailingAnchor, constant: -110),
            educationButton.heightAnchor.constraint(equalToConstant: 22),

            careerButton.topAnchor.constraint(equalTo: educationButton.bottomAnchor, constant: 18),
            careerButton.leadingAnchor.constraint(equalTo: mainContentView.leadingAnchor, constant: 14),
            careerButton.trailingAnchor.constraint(equalTo: mainContentView.trailingAnchor, constant: -110),
            careerButton.heightAnchor.constraint(equalToConstant: 22)
        ])
    }
}
