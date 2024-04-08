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

enum ChangeStates {
    case name
    case job
    case city
    case interests
    case contacts
    case surname
}

protocol FireStoreServiceProtocol {
    func getUser(id: String, completion: @escaping (Result<FirebaseUser, Error>) -> Void)
    func getPosts(id: String, completion: @escaping (Result<[EachPost], Error>) -> Void)
    func changeData(id: String, text: String, state: ChangeStates) async
}


final class FireStoreService: FireStoreServiceProtocol {


    func getUser(id: String, completion: @escaping (Result<FirebaseUser, Error>) -> Void) {
        let ref = Firestore.firestore().collection("Users").document(id)
        var firuser = FirebaseUser(name: "test",
                                   surname: "test",
                                   job: "test",
                                   subscribers: ["test"],
                                   subscriptions: ["test"],
                                   stories: ["test"],
                                   interests: ",",
                                   contacts: "fdfs",
                                   city: "TestCituy")
        firuser.id = ref.documentID
        ref.getDocument(as: FirebaseUser.self) { [weak self] result in
            guard self != nil else { return }
            switch result {
            case .success(let user):
                firuser.name = user.name
                firuser.job = user.job
                firuser.stories = user.stories
                firuser.subscribers = user.subscribers
                firuser.subscriptions = user.subscriptions
                firuser.contacts = user.contacts
                firuser.city = user.city
                firuser.interests = user.interests
                firuser.surname = user.surname
                completion(.success(firuser))
            case .failure(let error):
                print("Error in decoding doc \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
    }

    func getPosts(id: String, completion: @escaping (Result<[EachPost], Error>) -> Void) {
        let ref = Firestore.firestore().collection("Users").document(id).collection("posts")
        var posts: [EachPost] = []

        ref.getDocuments { snapshot, error in
            if let error = error {
                print("error in getting doc \(error.localizedDescription)")
                completion(.failure(error))
            }

            if let snapshot = snapshot {
                for document in snapshot.documents {
                    do {
                        var eachPost = EachPost(date: "", text: "", image: "", likes: 0, views: 0)
                        let firpost = try document.data(as: EachPost.self)
                        eachPost.date = firpost.date
                        eachPost.text = firpost.text
                        eachPost.image = firpost.image
                        eachPost.likes = firpost.likes
                        eachPost.views = firpost.views
                        posts.append(eachPost)
                    } catch {
                        print("error in getting data from doc \(error.localizedDescription)")
                        completion(.failure(error))
                    }
                }
                completion(.success(posts))
            }
        }
    }

    func changeData(id: String, text: String, state: ChangeStates) async {
        let ref = Firestore.firestore().collection("Users").document(id)

        switch state {
        case .name:
            do {
                try await ref.updateData(["name" : text])
            } catch {
                print("error in updating \(error.localizedDescription)")
            }
        case .job:
            do {
                try await ref.updateData(["job" : text])
            } catch {
                print("error in updating \(error.localizedDescription)")
            }
        case .city:
            do {
                try await ref.updateData(["city" : text])
            } catch {
                print("error in updating \(error.localizedDescription)")
            }
        case .interests:
            do {
                try await ref.updateData(["interests" : text])
            } catch {
                print("error in updating \(error.localizedDescription)")
            }
        case .contacts:
            do {
                try await ref.updateData(["contacts" : text])
            } catch {
                print("error in updating \(error.localizedDescription)")
            }
        case .surname:
            do {
                try await ref.updateData(["surname" : text])
            } catch {
                print("error in updating \(error.localizedDescription)")
            }
        }
    }
}

