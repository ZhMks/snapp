//
//  ExtensionTableVIew.swift
//  Snapp
//
//  Created by Максим Жуин on 04.05.2024.
//

import UIKit


extension UITableView {
    func setAndLayout(header: UIView) {
        tableHeaderView = header
        header.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            header.widthAnchor.constraint(equalTo: widthAnchor),
            header.leadingAnchor.constraint(equalTo: leadingAnchor),
            header.trailingAnchor.constraint(equalTo: trailingAnchor),
            header.topAnchor.constraint(equalTo: topAnchor),
        ])
        print(header.frame)
        
        header.layoutIfNeeded()
        header.frame.size = header.systemLayoutSizeFitting(UIView.layoutFittingExpandedSize)
        print(header.frame)
    }
}

