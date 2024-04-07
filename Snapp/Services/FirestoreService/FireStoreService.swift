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
    func decodeUser(snapshot: QuerySnapshot, user: String, firestoreUser: FirebaseUser) -> FirebaseUser
    func getPosts(user: String) 
}


final class FireStoreService: FireStoreServiceProtocol {

    func decodeUser(snapshot: QuerySnapshot, user: String, firestoreUser: FirebaseUser) -> FirebaseUser {
        var eachPost = EachPost(date: "", text: "", image: Data())
        var posts = Posts(postsArray: [eachPost])
        var userFire = FirebaseUser(name: "", surname: "", job: "", posts: posts)
        for document in snapshot.documents {
            if user == document.documentID {
                for (key, value) in document.data() {
                    if key == "name" {
                        userFire.name = (value as? String)!
                        print(value)
                    }
                    if key == "surname" {
                        userFire.surname = (value as? String)!
                        print(value)
                    }
                    if key == "job" {
                        userFire.job = (value as? String)!
                        print(value)
                    }
                }
            }
        }
        getPosts(user: user)
        return userFire
    }


    func getPosts(user: String) {
        let ref = Firestore.firestore().collection(user).document("Posts")
        ref.getDocument { snapshot, error in
            if let error = error {
                print(error.localizedDescription)
            }

            if let snapshotdata = snapshot?.data() {
                for (key, value) in snapshotdata {
                    print(key, value)
                }
            }
        }
    }
}
