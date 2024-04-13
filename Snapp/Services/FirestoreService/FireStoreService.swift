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
    func getPosts(id: String, completion: @escaping (Result<[String : [String : EachPost]], Error>) -> Void)
    func getEachPost(userid: String, documentid: String, completion: @escaping (Result<[String: EachPost], Error>) ->Void)
    func changeData(id: String, text: String, state: ChangeStates) async
    func createPost(date: String, time: String, text: String, image: UIImage, for user: UserMainModel, completion: @escaping (Result<EachPost, Error>) -> Void)
}


final class FireStoreService: FireStoreServiceProtocol {

    func getUser(id: String, completion: @escaping (Result<FirebaseUser, Error>) -> Void) {
        let dbReference = Firestore.firestore().collection("Users").document(id)
        dbReference.getDocument { snapshot, error in
            if let error = error {
                print("Error in gettingUser: \(error.localizedDescription)")
                completion(.failure(error))
            }

            if let snapshot = snapshot {
                do {
                    let currentUser = try snapshot.data(as: FirebaseUser.self)
                    completion(.success(currentUser))
                } catch {
                    completion(.failure(error))
                }
            }


        }
    }

    func getPosts(id: String, completion: @escaping (Result<[String : [String : EachPost]], Error>) -> Void) {
        let ref = Firestore.firestore().collection("Users").document(id).collection("posts")
        var posts: [String : [String : EachPost]] = [:]

        ref.getDocuments { snapshot, error in
            if let error = error {
                print("error in getting doc \(error.localizedDescription)")
                completion(.failure(error))
            }

            if let snapshot = snapshot {
                if !snapshot.documents.isEmpty {
                    for document in snapshot.documents {
                        self.getEachPost(userid: id, documentid: document.documentID) { result in
                            switch result {
                            case .success(let success):
                                print(success.keys)
                                print(success.values)
                                posts.updateValue(success, forKey: document.documentID)
                            case .failure(let failure):
                                completion(.failure(failure))
                            }
                            completion(.success(posts))
                        }
                    }
                } else {
                    let currentDate = Date()
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "dd-MM-yyyy"
                    let dateString =  dateFormatter.string(from: currentDate)
                    posts.updateValue([:], forKey: dateString)
                    completion(.success(posts))
                }
            }
        }
    }

    func getEachPost(userid: String, documentid: String, completion: @escaping (Result<[String: EachPost], Error>) ->Void) {
        let postRef = Firestore.firestore().collection("Users").document(userid).collection("posts").document(documentid)
        var postsArray: [String : EachPost] = [:]

        postRef.collection("PostsInThisDate").getDocuments { snapshot, error in
            if let error = error {
                completion(.failure(error))
            }

            if let snapshot = snapshot {
                var eachPost = EachPost(text: "", image: "", likes: 0, views: 0)
                for document in snapshot.documents {
                    do {
                        let firPost = try document.data(as: EachPost.self)
                        eachPost.image = firPost.image
                        eachPost.text = firPost.text
                        eachPost.likes = firPost.likes
                        eachPost.views = firPost.views
                        postsArray.updateValue(eachPost, forKey: document.documentID)
                    } catch {
                        completion(.failure(error))
                    }
                }
                completion(.success(postsArray))
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

    func createUser(user: FirebaseUser, id: String) {
        print(id)
        Firestore.firestore().collection("Users").document(id).setData([
            "name" : user.name,
            "job" : user.job,
            "city" : user.city,
            "contacts" : user.contacts,
            "interests" : user.interests,
            "surname" : user.surname,
            "subscribers" : user.subscribers,
            "stories" : user.stories,
            "subscribtions" : user.subscribtions,
            "image" : user.image
        ])
    }

    func saveImageIntoStorage(urlLink: StorageReference, photo: UIImage, for user: String, completion: @escaping (Result <URL, Error>) -> Void) {
        guard let imageData = photo.jpegData(compressionQuality: 0.7) else { return }
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpeg"

        urlLink.putData(imageData, metadata: metaData) { metada, error in
            guard let metadata = metada else {
                completion(.failure(error!))
                return
            }

            urlLink.downloadURL { url, error in
                guard let url = url else {
                    completion(.failure(error!))
                    return
                }
                completion(.success(url))
            }
        }
    }

    func createPost(date: String, time: String, text: String, image: UIImage, for user: UserMainModel, completion: @escaping (Result<EachPost, Error>) -> Void) {
        print(user.id)
        let docRef = Firestore.firestore().collection("Users").document(user.id!).collection("posts").document(date).collection(time).document()
        let postRef = Storage.storage().reference().child("users").child(user.id!).child("posts").child(date)
        var fireStorePost = EachPost(text: "", image: "", likes: 0, views: 0)
        saveImageIntoStorage(urlLink: postRef, photo: image, for: user.id!) { result in
            switch result {
            case .success(let url):
                fireStorePost.image = url.absoluteString
                fireStorePost.text = text
                docRef.setData([
                    "text" : fireStorePost.text,
                    "image" : fireStorePost.image,
                    "likes" : fireStorePost.likes,
                    "views" : fireStorePost.views
                ])
                completion(.success(fireStorePost))
            case .failure(let error):
                print(error.localizedDescription)
                completion(.failure(error))
            }
        }
    }
}

