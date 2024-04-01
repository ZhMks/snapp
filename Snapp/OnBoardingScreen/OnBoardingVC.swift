//
//  ViewController.swift
//  Snapp
//
//  Created by Максим Жуин on 01.04.2024.
//

import UIKit

class OnBoardingVC: UIViewController {

    private let onboardingView: OnBoardingView


    init(onboardingView: OnBoardingView) {
        self.onboardingView = onboardingView
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemRed
    }


}

