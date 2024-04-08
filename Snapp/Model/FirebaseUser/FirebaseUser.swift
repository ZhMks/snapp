//
//  FirebaseUser.swift
//  Snapp
//
//  Created by Максим Жуин on 03.04.2024.
//

import Foundation
import FirebaseAuth
import UIKit
import FirebaseFirestore

struct FirebaseUser: Codable {
    @DocumentID var id: String?
    var name: String
    var surname: String
    var job: String
    var subscribers: [String]
    var subscriptions: [String]
    var stories: [String]
}

struct EachPost: Codable {
    var date: String
    var text: String
    var image: String
    var likes: Int
    var views: Int
}
