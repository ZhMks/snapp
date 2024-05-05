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
    func getAllUsers(completion: @escaping (Result<[FirebaseUser], Error>) -> Void)
    func getUser(id: String, completion: @escaping (Result<FirebaseUser, AuthorisationErrors>) -> Void)
    func getPosts(sub: String, completion: @escaping (Result<[MainPost], Error>) -> Void)
    func getEachPost(userid: String, documentID: String, completion: @escaping (Result<[EachPost], Error>) ->Void)
    func changeData(id: String, text: String, state: ChangeStates) async
    func createPost(date: String, text: String, image: UIImage, for user: String, completion: @escaping (Result<EachPost, Error>) -> Void)
    func saveImageIntoStorage(urlLink: StorageReference, photo: UIImage, completion: @escaping (Result <URL, Error>) -> Void)
    func createUser(user: FirebaseUser, id: String)
}


final class FireStoreService: FireStoreServiceProtocol {


    func getAllUsers(completion: @escaping (Result<[FirebaseUser], Error>) -> Void) {
        let dbReference = Firestore.firestore().collection("Users")
        dbReference.getDocuments { snapshot, error in
            if let error = error {
                completion(.failure(error))
            }
            if let snapshot = snapshot {
                var usersArray: [FirebaseUser] = []
                do {
                    for document in snapshot.documents {
                        let currentUser = try document.data(as: FirebaseUser.self)
                        usersArray.append(currentUser)
                    }
                } catch {
                    completion(.failure(error))
                }
                completion(.success(usersArray))
            }
        }
    }

    func getUser(id: String, completion: @escaping (Result<FirebaseUser, AuthorisationErrors>) -> Void) {
        let dbReference = Firestore.firestore().collection("Users")
        dbReference.getDocuments { snapshot, error in
            if let error = error {
                print("Error in gettingUser: \(error.localizedDescription)")
                completion(.failure(.invalidCredential))
            }

            if let snapshot = snapshot {
                if snapshot.documents.isEmpty {
                    completion(.failure(.userAlreadyExist))
                }
                for document in snapshot.documents {
                    if document.documentID == id {
                        do {
                            let currentUser = try document.data(as: FirebaseUser.self)
                            completion(.success(currentUser))
                        } catch {
                            completion(.failure(.operationNotAllowed))
                        }
                    }
                }
            }
        }
    }

    func getPosts(sub: String, completion: @escaping (Result<[MainPost], Error>) -> Void)  {

        let refDB = Firestore.firestore().collection("Users").document(sub).collection("posts")
        var posts: [MainPost] = []

        refDB.getDocuments { [weak self] snapshot, error in
            guard let self else { return }

            if let error = error {
                print(error.localizedDescription)
                completion(.failure(error))
            }

            if let snapshot = snapshot {
                if snapshot.documents.isEmpty {
                    return
                }

                for document in snapshot.documents {
                    if let currentDate = document.data().values.first as? String {
                        getEachPost(userid: sub, documentID: document.documentID) { result in
                            switch result {
                            case .success(let success):
                                print("Success: \(success)")
                                let mainPost = MainPost(date: currentDate, postsArray: success)
                                posts.append(mainPost)
                            case .failure(let failure):
                                completion(.failure(failure))
                            }
                        }
                    }
                }
                completion(.success(posts))
            }
        }
    }

    func getEachPost(userid: String, documentID: String, completion: @escaping (Result<[EachPost], Error>) ->Void) {
        print(userid, documentID)
        let postRef = Firestore.firestore().collection("Users").document(userid).collection("posts").document(documentID).collection("eachPost")
        var postsArray: [EachPost] = []

        postRef.getDocuments { snapshot, error in

            if let error = error {
                completion(.failure(error))
            }

            if let snapshot = snapshot {
                for document in snapshot.documents {
                    do {
                        let eachPostData = try document.data(as: EachPost.self)
                        postsArray.append(eachPostData)
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
        do {
            try Firestore.firestore().collection("Users").document(id).setData(from: user)
        } catch {
            print(error.localizedDescription)
        }
    }

    func saveImageIntoStorage(urlLink: StorageReference, photo: UIImage, completion: @escaping (Result <URL, Error>) -> Void) {
        guard let imageData = photo.jpegData(compressionQuality: 0.7) else { return }
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpeg"

        urlLink.putData(imageData, metadata: metaData) { metada, error in
            guard let _ = metada else {
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

    func createPost(date: String, text: String, image: UIImage, for user: String, completion: @escaping (Result<EachPost, Error>) -> Void) {
        let postRef = Firestore.firestore().collection("Users").document(user).collection("posts")
        let postStorageRef = Storage.storage().reference().child("users").child(user).child("posts").child(date)
        var fireStorePost = EachPost(text: "", image: "", likes: 0, views: 0)

        saveImageIntoStorage(urlLink: postStorageRef, photo: image) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let url):
                fireStorePost.image = url.absoluteString
                fireStorePost.text = text

                postRef.getDocuments { snapshot, error in
                    if let error = error {}

                    if let snapshot = snapshot {
                        var documentRef : DocumentReference?
                        if snapshot.documents.isEmpty {
                            documentRef =  postRef.addDocument(data: [ "date" : date ])
                        } else {
                            for document in snapshot.documents {
                                if document.data().values.contains(where: { $0 as? String == date }) {
                                    documentRef = document.reference
                                }
                            }
                            if documentRef == nil {
                                documentRef = postRef.addDocument(data: ["date" : date ])
                            }
                        }
                        guard let documentRef = documentRef else { return }
                        if self.createEachPost(docRef: documentRef, post: fireStorePost) {
                            completion(.success(fireStorePost))
                        }
                    }
                }
            case .failure(let error):
                print(error.localizedDescription)
                completion(.failure(error))
            }
        }
    }

    func createEachPost(docRef: DocumentReference, post: EachPost) -> Bool {

        let eachPostRef = docRef.collection("eachPost").document()

        do {
            try eachPostRef.setData(from: post)
            return true
        } catch {
            print(error.localizedDescription)
            return false
        }
    }

    func saveSubscriber(mainUser: String, id: String) {
        let docRef = Firestore.firestore().collection("Users").document(mainUser)
        docRef.updateData(["subscribers" : id])
    }

    func saveUserStorie(user: FirebaseUser, image: UIImage, date: String, completion: @escaping (Result <URL, Error>) -> Void) {
        print(user.identifier)
        let docRef = Firestore.firestore().collection("Users").document(user.identifier)
        let postRef = Storage.storage().reference().child("users").child(user.identifier).child("stories").child(date)

        saveImageIntoStorage(urlLink: postRef, photo: image) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let url):
                docRef.updateData(["stories" : url])
                completion(.success(url))
            case .failure(let failure):
                print(failure.localizedDescription)
                completion(.failure(failure))
            }
        }
    }
}

