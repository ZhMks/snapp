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

enum PostErrors: Error {
    case empty
    case errorInDecode
    case getError

    var description: String {
        switch self {
        case .getError:
            "Ошибка сервера"
        case .empty:
            "Посты отсутстуют"
        case .errorInDecode:
            "Ошибка декодирования"
        }
    }
}

protocol FireStoreServiceProtocol {
    func getAllUsers(completion: @escaping (Result<[FirebaseUser], Error>) -> Void)
    func getUser(id: String, completion: @escaping (Result<FirebaseUser, AuthorisationErrors>) -> Void)
    func getPosts(sub: String, completion: @escaping (Result<[EachPost], PostErrors>) -> Void)
    func changeData(id: String, text: String, state: ChangeStates) async
    func createPost(date: String, text: String, image: UIImage?, for user: String, completion: @escaping (Result<EachPost, Error>) -> Void)
    func saveImageIntoStorage(urlLink: StorageReference, photo: UIImage, completion: @escaping (Result <URL, Error>) -> Void)
    func createUser(user: FirebaseUser, id: String)
    func saveSubscriber(mainUser: String, id: String)
    func saveImageIntoPhotoAlbum(image: String, user: String)
    func addComment(mainUser: String, text: String, documentID: String, commentor: String, completion: @escaping (Result<Comment, Error>) -> Void)
    func getComments(post: String, user: String, completion: @escaping (Result<[Comment], Error>) -> Void)
    func addAnswerToComment(postID: String, user: String, commentID: String, answer: Answer, completion: @escaping (Result<Answer, Error>) -> Void)
    func getAnswers(post: String, comment: String, user: String, completion: @escaping (Result<[Answer], Error>) -> Void)
    func saveIntoFavourites(post: EachPost, for user: String, completion: @escaping (Result<EachPost, Error>) -> Void)
    func getDocLink(for id: String, user: String) -> String
    func disableCommentaries(id: String, user: String)
    func addDocToArchives(post: EachPost, user: String, completion: @escaping (Result<EachPost, Error>) -> Void)
    func addSnapshotListenerToPosts(for user: String, completion: @escaping (Result<[EachPost], Error>) -> Void)
    func addSnapshotListenerToUser(for user: String, completion: @escaping (Result<FirebaseUser, Error>) -> Void)
    func removeListenerForPosts()
    func removeListenerForUser()
    func deleteDocument(docID: String, user: String, completion: @escaping (Result<Bool, Error>) -> Void)
    func removeSubscribtion(sub: String, for user: String)
    func addSnapshotListenerToCurrentPost(docID: String, userID: String, completion: @escaping (Result<EachPost, Error>) -> Void)
    func removeListenerForCurrentPost()
}


final class FireStoreService: FireStoreServiceProtocol {

    var postListner: ListenerRegistration?

    var userListner: ListenerRegistration?

    var currentPostListner: ListenerRegistration?

    func addSnapshotListenerToUser(for user: String, completion: @escaping (Result<FirebaseUser, Error>) -> Void) {
        let ref = Firestore.firestore().collection("Users").document(user)
        self.userListner = ref.addSnapshotListener({ snapshot, error in
            if let error = error {
                completion(.failure(error))
            }

            if let snapshot = snapshot {
                do {
                    let user = try snapshot.data(as: FirebaseUser.self)
                    completion(.success(user))
                } catch let DecodingError.dataCorrupted(context) {
                    print(context)
                } catch let DecodingError.keyNotFound(key, context) {
                    print("Key '\(key)' not found:", context.debugDescription)
                    print("codingPath:", context.codingPath)
                } catch let DecodingError.valueNotFound(value, context) {
                    print("Value '\(value)' not found:", context.debugDescription)
                    print("codingPath:", context.codingPath)
                } catch let DecodingError.typeMismatch(type, context)  {
                    print("Type '\(type)' mismatch:", context.debugDescription)
                    print("codingPath:", context.codingPath)
                } catch {
                    print("error: ", error)
                    completion(.failure(error))
                }
            }
        })
    }

    func removeListenerForUser() {
        self.userListner?.remove()
    }

    func addSnapshotListenerToPosts(for user: String, completion: @escaping (Result<[EachPost], Error>) -> Void) {
        let ref =  Firestore.firestore().collection("Users").document(user).collection("posts")
        var updatedArray: [EachPost] = []
        let dispatchGroup = DispatchGroup()
        self.postListner = ref.addSnapshotListener { snapshot, error in
            if let error = error {
                completion(.failure(error))
            }

            if let snapshot = snapshot {
                if snapshot.documents.isEmpty {
                    updatedArray = []
                    completion(.success(updatedArray))
                } else {
                    updatedArray = []
                    for document in snapshot.documents {
                        dispatchGroup.enter()
                        do {
                            let post = try  document.data(as: EachPost.self)
                            updatedArray.append(post)
                        } catch {
                            completion(.failure(error))
                        }
                        dispatchGroup.leave()
                    }
                    dispatchGroup.notify(queue: .main) {
                        print(updatedArray)
                        completion(.success(updatedArray))
                    }
                }
            }
        }
    }

    func removeListenerForPosts() {
        postListner?.remove()
    }

    func addSnapshotListenerToCurrentPost(docID: String, userID: String, completion: @escaping (Result<EachPost, Error>) -> Void) {
        let ref =  Firestore.firestore().collection("Users").document(userID).collection("posts").document(docID)
        self.currentPostListner = ref.addSnapshotListener { docSnapshot, error in
            if let error = error {
                completion(.failure(error))
            }

            if let docSnapshot = docSnapshot {
                do {
                    let doc = try docSnapshot.data(as: EachPost.self)
                    completion(.success(doc))
                } catch let DecodingError.dataCorrupted(context) {
                    print(context)
                } catch let DecodingError.keyNotFound(key, context) {
                    print("Key '\(key)' not found:", context.debugDescription)
                    print("codingPath:", context.codingPath)
                } catch let DecodingError.valueNotFound(value, context) {
                    print("Value '\(value)' not found:", context.debugDescription)
                    print("codingPath:", context.codingPath)
                } catch let DecodingError.typeMismatch(type, context)  {
                    print("Type '\(type)' mismatch:", context.debugDescription)
                    print("codingPath:", context.codingPath)
                } catch {
                    print("error: ", error)
                    completion(.failure(error))
                }
            }
        }
    }

    func removeListenerForCurrentPost() {
        self.currentPostListner?.remove()
    }

    func getAllUsers(completion: @escaping (Result<[FirebaseUser], Error>) -> Void) {
        let dbReference = Firestore.firestore().collection("Users")
        dbReference.getDocuments { snapshot, error in
            if let error = error {
                completion(.failure(error))
            }
            if let snapshot = snapshot {
                let dispatchGroup = DispatchGroup()
                var usersArray: [FirebaseUser] = []
                do {
                    dispatchGroup.enter()
                    for document in snapshot.documents {
                        let currentUser = try document.data(as: FirebaseUser.self)
                        usersArray.append(currentUser)
                    }
                    dispatchGroup.leave()
                } catch {
                    print(error.localizedDescription)
                    completion(.failure(error))
                }
                dispatchGroup.notify(queue: .main) {
                    completion(.success(usersArray))
                }
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
                        } catch let DecodingError.dataCorrupted(context) {
                            print(context)
                        } catch let DecodingError.keyNotFound(key, context) {
                            print("Key '\(key)' not found:", context.debugDescription)
                            print("codingPath:", context.codingPath)
                        } catch let DecodingError.valueNotFound(value, context) {
                            print("Value '\(value)' not found:", context.debugDescription)
                            print("codingPath:", context.codingPath)
                        } catch let DecodingError.typeMismatch(type, context)  {
                            print("Type '\(type)' mismatch:", context.debugDescription)
                            print("codingPath:", context.codingPath)
                        } catch {
                            print("error: ", error)
                        }
                    } else {
                        completion(.failure(.invalidCredential))
                    }
                }
            }
        }
    }

    func getPosts(sub: String, completion: @escaping (Result<[EachPost], PostErrors>) -> Void)  {

        let refDB = Firestore.firestore().collection("Users").document(sub).collection("posts")
        var posts: [EachPost] = []
        
        refDB.getDocuments { snapshot, error in
            
            if let error = error {
                print(error.localizedDescription)
                completion(.failure(.getError))
            }
            let dispatchGroup = DispatchGroup()
            if let snapshot = snapshot {
                if snapshot.documents.isEmpty {
                    return
                }
                dispatchGroup.enter()
                for document in snapshot.documents {
                    do {
                        let eachPost = try document.data(as: EachPost.self)
                        posts.append(eachPost)
                    } catch {
                        print(error.localizedDescription)
                    }
                }
                dispatchGroup.leave()
            }
            dispatchGroup.notify(queue: .main) {
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

    func createUser(user: FirebaseUser, id: String) {
        do {
            try Firestore.firestore().collection("Users").document(id).setData(from: user)
        } catch {
            print(error.localizedDescription)
        }
    }

    func saveImageIntoStorage(urlLink: StorageReference, photo: UIImage, completion: @escaping (Result <URL, Error>) -> Void) {
        guard let imageData = photo.jpegData(compressionQuality: 0.5) else { return }
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

    func createPost(date: String, text: String, image: UIImage?, for user: String, completion: @escaping (Result<EachPost, Error>) -> Void) {
        let postRef = Firestore.firestore().collection("Users").document(user).collection("posts")
        var fireStorePost = EachPost(text: "", image: "", likes: 0, commentaries: 0, date: date, isCommentariesEnabled: true)

        if let image = image {
            let postStorageRef = Storage.storage().reference().child("users").child(user).child("posts").child(date).child(image.description)
            saveImageIntoStorage(urlLink: postStorageRef, photo: image) { [weak self] result in
                guard self != nil else { return }
                switch result {
                case .success(let url):
                    fireStorePost.image = url.absoluteString
                    fireStorePost.text = text
                    do {
                        try postRef.addDocument(from: fireStorePost)
                        completion(.success(fireStorePost))
                    } catch {
                        print(error.localizedDescription)
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                    completion(.failure(error))
                }
            }
        } else {
            fireStorePost.text = text
            do {
                try postRef.addDocument(from: fireStorePost)
                completion(.success(fireStorePost))
            } catch {
                print(error.localizedDescription)
            }
        }
    }

    func saveSubscriber(mainUser: String, id: String) {
        let docRef = Firestore.firestore().collection("Users").document(mainUser)
        docRef.updateData(["subscribtions" : FieldValue.arrayUnion([id])])
        let selfRef = Firestore.firestore().collection("Users").document(id)
        selfRef.updateData(["subscribers" : FieldValue.arrayUnion([mainUser])])
    }

    func saveImageIntoPhotoAlbum(image: String, user: String) {
        let docRef = Firestore.firestore().collection("Users").document(user)
        docRef.updateData(["photoAlbum" : FieldValue.arrayUnion([image])])
    }

    func addComment(mainUser: String, text: String, documentID: String, commentor: String, completion: @escaping (Result<Comment, Error>) -> Void) {
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM"
        let stringFromDate = dateFormatter.string(from: date)


        let likes = 0
        let commentRef = Firestore.firestore().collection("Users").document(mainUser).collection("posts").document(documentID).collection("comments")
        let docRef = Firestore.firestore().collection("Users").document(mainUser).collection("posts").document(documentID)

        let comment = Comment(text: text, commentor: commentor, date: stringFromDate, likes: likes)
        do {
            try commentRef.addDocument(from: comment)
            completion(.success(comment))
            docRef.updateData(["commentaries": FieldValue.increment(Int64(1))])
        } catch {
            print(error.localizedDescription)
            completion(.failure(error))
        }
    }

    func getComments(post: String, user: String, completion: @escaping (Result<[Comment], Error>) -> Void) {
        let docReft = Firestore.firestore().collection("Users").document(user).collection("posts").document(post).collection("comments")
        var commentsArray: [Comment] = []

        docReft.getDocuments { snapshot, error in
            if let error = error {
                completion(.failure(error))
            }

            if let snapshot = snapshot {
                for document in snapshot.documents {
                    do {
                        let comment = try document.data(as: Comment.self)
                        commentsArray.append(comment)
                    } catch let DecodingError.dataCorrupted(context) {
                        print(context)
                    } catch let DecodingError.keyNotFound(key, context) {
                        print("Key '\(key)' not found:", context.debugDescription)
                        print("codingPath:", context.codingPath)
                    } catch let DecodingError.valueNotFound(value, context) {
                        print("Value '\(value)' not found:", context.debugDescription)
                        print("codingPath:", context.codingPath)
                    } catch let DecodingError.typeMismatch(type, context)  {
                        print("Type '\(type)' mismatch:", context.debugDescription)
                        print("codingPath:", context.codingPath)
                    } catch {
                        print("error: ", error)
                        completion(.failure(error))
                    }
                }
            }
                completion(.success(commentsArray))
        }
    }

    func addAnswerToComment(postID: String, user: String, commentID: String, answer: Answer, completion: @escaping (Result<Answer, Error>) -> Void) {
        let docReft = Firestore.firestore().collection("Users").document(user).collection("posts").document(postID).collection("comments").document(commentID).collection("answers")
        do {
            try docReft.addDocument(from: answer)
            completion(.success(answer))
        } catch let DecodingError.dataCorrupted(context) {
            print(context)
        } catch let DecodingError.keyNotFound(key, context) {
            print("Key '\(key)' not found:", context.debugDescription)
            print("codingPath:", context.codingPath)
        } catch let DecodingError.valueNotFound(value, context) {
            print("Value '\(value)' not found:", context.debugDescription)
            print("codingPath:", context.codingPath)
        } catch let DecodingError.typeMismatch(type, context)  {
            print("Type '\(type)' mismatch:", context.debugDescription)
            print("codingPath:", context.codingPath)
        } catch {
            print("error: ", error)
            completion(.failure(error))
        }
    }

    func getAnswers(post: String, comment: String, user: String, completion: @escaping (Result<[Answer], Error>) -> Void) {
        let docReft = Firestore.firestore().collection("Users").document(user).collection("posts").document(post).collection("comments").document(comment).collection("answers")
        var answers: [Answer] = []

        docReft.getDocuments { snapshot, error in
            
            if let error = error {
                completion(.failure(error))
            }

            if let snapshot = snapshot {
                if !snapshot.documents.isEmpty {
                    for document in snapshot.documents {
                        do {
                            let answer = try document.data(as: Answer.self)
                            print(answer)
                            answers.append(answer)
                        }
                        catch let DecodingError.dataCorrupted(context) {
                            print(context)
                        } catch let DecodingError.keyNotFound(key, context) {
                            print("Key '\(key)' not found:", context.debugDescription)
                            print("codingPath:", context.codingPath)
                        } catch let DecodingError.valueNotFound(value, context) {
                            print("Value '\(value)' not found:", context.debugDescription)
                            print("codingPath:", context.codingPath)
                        } catch let DecodingError.typeMismatch(type, context)  {
                            print("Type '\(type)' mismatch:", context.debugDescription)
                            print("codingPath:", context.codingPath)
                        } catch {
                            print("error: ", error)
                            completion(.failure(error))
                        }
                    }
                    completion(.success(answers))
                }
            }
        }
    }

    func saveIntoFavourites(post: EachPost, for user: String, completion: @escaping (Result<EachPost, Error>) -> Void) {
        let docRef = Firestore.firestore().collection("Users").document(user).collection("Favourites")

        do {
           try docRef.addDocument(from: post)
            completion(.success(post))
        } catch {
            print(error.localizedDescription)
            completion(.failure(error))
        }
    }

    func disableCommentaries(id: String, user: String) {
        let docRef = Firestore.firestore().collection("Users").document(user).collection("posts").document(id)
        docRef.updateData(["isCommentariesEnabled" : false])
    }

    func getDocLink(for id: String, user: String) -> String {
    let docRef = Firestore.firestore().collection("Users").document(user).collection("posts").document(id)
        return docRef.path.description
    }

    func addDocToArchives(post: EachPost, user: String, completion: @escaping (Result<EachPost, Error>) -> Void) {
        guard let documentID = post.documentID else {
            return
        }
        let archiveRef = Firestore.firestore().collection("Users").document(user).collection("Archive")
        let dispatchGroup = DispatchGroup()
        var newPost = post

        if let image = post.image {
            let networkService = NetworkService()
            networkService.fetchImage(string: image) { [weak self] result in
                guard let self else { return }
                switch result {
                case .success(let success):
                    dispatchGroup.enter()
                    guard let image = UIImage(data: success) else { return }
                    let storagRef = Storage.storage().reference().child("users").child(user).child("archive").child(post.date)
                    saveImageIntoStorage(urlLink: storagRef, photo: image) { [weak self] result in
                        guard self != nil else { return }
                        switch result {
                        case .success(let success):
                            newPost.image = success.absoluteString
                            self?.deleteDocument(docID: documentID, user: user) { [weak self] result in
                                guard  self != nil else { return }
                                switch result {
                                case .success(_):
                                    dispatchGroup.leave()
                                case .failure(let failure):
                                    completion(.failure(failure))
                                }
                            }
                        case .failure(let failure):
                            completion(.failure(failure))
                        }
                    }
                case .failure(let failure):
                    completion(.failure(failure))
                }
                dispatchGroup.notify(queue: .main) {
                    do {
                        try archiveRef.addDocument(from: newPost)
                        completion(.success(newPost))
                    } catch {
                        completion(.failure(error))
                    }
                }
            }
        }
    }

    func deleteDocument(docID: String, user: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        let docRef = Firestore.firestore().collection("Users").document(user).collection("posts").document(docID)
        docRef.delete { error in
            if let error = error {
                completion(.failure(error))
            }
            completion(.success(true))
        }
    }

    func removeSubscribtion(sub: String, for user: String) {
        let docRef = Firestore.firestore().collection("Users").document(user)
        docRef.updateData(["subscribtions" : FieldValue.arrayRemove([sub])])
    }

}

