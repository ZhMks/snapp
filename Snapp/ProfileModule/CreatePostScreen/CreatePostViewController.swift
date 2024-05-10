//
//  CreatePostViewController.swift
//  Snapp
//
//  Created by Максим Жуин on 10.05.2024.
//

import UIKit

class CreatePostViewController: UIViewController {

    // MARK: -PROPERTIES

    var presenter: CreatePostPresenterProtocol!


    private lazy var createPostTextView: UITextView = {
        let creaPostTextView = UITextView()
        creaPostTextView.translatesAutoresizingMaskIntoConstraints = false
        creaPostTextView.font = UIFont(name: "Inter-Light", size: 12)
        creaPostTextView.textColor = ColorCreator.shared.createTextColor()
        creaPostTextView.textAlignment = .left
        return creaPostTextView
    }()

    private lazy var addImageButton: UIButton = {
        let addImageButton = UIButton()
        addImageButton.translatesAutoresizingMaskIntoConstraints = false
        addImageButton.setBackgroundImage(UIImage(systemName: "photo.circle"), for: <#T##UIControl.State#>)
    }()

    // MARK: -LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
}
    
        // MARK: -FUNCS

}

// MARK: -OUTPUT PRESENTER

extension CreatePostViewController: CreatePostViewProtocol {}


// MARK: -LAYOUT

extension CreatePostViewController {
    func addSubviews() {

        
    }

    func layout() {
        let safeArea = view.safeAreaLayoutGuide

    }
}
