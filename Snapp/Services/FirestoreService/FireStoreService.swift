//
//  FireStoreService.swift
//  Snapp
//
//  Created by Максим Жуин on 05.04.2024.
//

import UIKit
import FirebaseFirestore
import FirebaseStorage
import FirebaseFirestoreSwift

protocol FireStoreServiceProtocol {
    func getUser(id: String)
    func getPosts(id: String)
}


final class FireStoreService: FireStoreServiceProtocol {

    func getUser(id: String) {
        let ref = Firestore.firestore().collection("Users").document(id)
        let docoder = JSONDecoder()
        var firuser = FirebaseUser(name: "", surname: "", job: "", subscribers: [""], subscriptions: [""], stories: [""])
        getPosts(id: id)
        ref.getDocument(as: FirebaseUser.self) { result in
            switch result {
            case .success(let user):
                firuser.name = user.name
                firuser.job = user.job
                firuser.stories = user.stories
                firuser.subscribers = user.subscribers
                firuser.subscriptions = user.subscriptions
                print(firuser)
            case .failure(let error):
                print("Error in decoding doc \(error.localizedDescription)")
            }
        }
    }

    func getPosts(id: String) {
        let ref = Firestore.firestore().collection("Users").document(id).collection("posts")
        let decoder = JSONDecoder()
        var posts: [EachPost] = []

        ref.getDocuments { snapshot, error in
            if let error = error {
                print("error in getting doc \(error.localizedDescription)")
            }

            if let snapshot = snapshot {
                var eachPost = EachPost(date: "", text: "", image: "", likes: 0, views: 0)
                for document in snapshot.documents {
                    do {
                        let firpost = try document.data(as: EachPost.self)
                        eachPost.date = firpost.date
                        eachPost.text = firpost.text
                        eachPost.image = firpost.image
                        eachPost.likes = firpost.likes
                        eachPost.views = firpost.views
                        posts.append(eachPost)
                        print(posts)
                    } catch {
                        print("error in getting data from doc \(error.localizedDescription)")
                    }
                }
            }
        }
    }
}
