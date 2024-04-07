//
//  FirebaseUser.swift
//  Snapp
//
//  Created by Максим Жуин on 03.04.2024.
//

import Foundation
import FirebaseAuth
import UIKit

struct FirebaseUser: Codable {
    var name: String
    var surname: String
    var job: String
    var posts: Posts
}


struct Posts: Codable {
    var postsArray: [EachPost]
}

struct EachPost: Codable {
    var date: String
    var text: String
    var image: Data
}
