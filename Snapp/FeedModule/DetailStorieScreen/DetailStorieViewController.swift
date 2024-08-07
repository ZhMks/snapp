//
//  DetailStorieViewController.swift
//  Snapp
//
//  Created by Максим Жуин on 06.07.2024.
//

import UIKit

class DetailStorieViewController: UIViewController {

    // MARK: - Properties
    var presenter: DetailStoriePresenter!

    private lazy var storiesScrollView: UIScrollView = {
        let storiesSCrollView = UIScrollView()
        storiesSCrollView.translatesAutoresizingMaskIntoConstraints = false
        storiesSCrollView.isPagingEnabled = true
        storiesSCrollView.showsHorizontalScrollIndicator = false
        storiesSCrollView.contentSize = CGSize(width: storiesSCrollView.frame.size.width, height: storiesSCrollView.frame.size.height)
        storiesSCrollView.delegate = self
        return storiesSCrollView
    }()

    private lazy var storiesPageControle: UIPageControl = {
        let storiesPageControle = UIPageControl()
        storiesPageControle.translatesAutoresizingMaskIntoConstraints = false
        storiesPageControle.pageIndicatorTintColor = .lightGray
        storiesPageControle.currentPageIndicatorTintColor = .white
        storiesPageControle.backgroundStyle = .prominent
        return storiesPageControle
    }()

    private lazy var backButton: UIButton = {
        let backButton = UIButton(type: .system)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.setBackgroundImage(UIImage(systemName: "xmark"), for: .normal)
        backButton.tintColor = .systemOrange
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        return backButton
    }()


    // MARK: - Lifecycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tuneNavItem()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        addSubviews()
        layout()
        presenter.fetchSubscribersStorie()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }

    // MARK: - Funcs
    @objc func backButtonTapped() {
        self.navigationController?.popViewController(animated: true)
    }
}

// MARK: - Presenter Output
extension DetailStorieViewController: DetailStorieViewProtocol {

    func showError(descr: String) {
        print()
    }

    func updateView(images: [UIImage]) {
        for (index, imageName) in images.enumerated() {
            let imageView = UIImageView(frame: CGRect(x: storiesScrollView.frame.size.width * CGFloat(index),
                                                      y: 0,
                                                      width: storiesScrollView.frame.size.width,
                                                      height: storiesScrollView.frame.size.height))
            imageView.image = imageName
            storiesPageControle.numberOfPages = images.count
            storiesPageControle.currentPage = 0
            storiesScrollView.addSubview(imageView)
        }
        storiesScrollView.contentSize = CGSize(width: view.bounds.width * CGFloat(images.count), height: view.bounds.height)

        storiesPageControle.numberOfPages = images.count
        storiesPageControle.currentPage = 0
    }

    func tuneNavItem() {
        self.navigationController?.navigationBar.isHidden = true
    }


}

// MARK: - ScrollView Delegate
extension DetailStorieViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = round(scrollView.contentOffset.x / view.bounds.width)
        storiesPageControle.currentPage = Int(pageIndex)
    }
}


// MARK: - Layout

extension DetailStorieViewController {
    private func addSubviews() {
        view.addSubview(storiesScrollView)
        view.addSubview(storiesPageControle)
        view.addSubview(backButton)
    }

    private func layout() {
        let safeArea = view.safeAreaLayoutGuide

        NSLayoutConstraint.activate([
            storiesScrollView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 15),
            storiesScrollView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            storiesScrollView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            storiesScrollView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),

            storiesPageControle.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -10),
            storiesPageControle.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 20),
            storiesPageControle.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -20),

            backButton.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 10),
            backButton.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -10),
            backButton.widthAnchor.constraint(equalToConstant: 30),
            backButton.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
}
