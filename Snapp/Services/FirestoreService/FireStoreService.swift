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
    case identifier
    case interests
    case contacts
    case surname
    case storie
    case dateOfBirth
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
    // Функции для работы с пользователем
    func getAllUsers(completion: @escaping (Result<[FirebaseUser], Error>) -> Void)
    func getUser(id: String, completion: @escaping (Result<FirebaseUser, AuthorisationErrors>) -> Void)
    func createUser(user: FirebaseUser, id: String)
    func saveSubscriber(mainUser: String, id: String)
    func addSnapshotListenerToUser(for user: String, completion: @escaping (Result<FirebaseUser, Error>) -> Void)
    func removeListenerForUser()
    func changeData(id: String, text: String, state: ChangeStates)

    // Функции для работы с постом
    func getPosts(sub: String, completion: @escaping (Result<[EachPost], PostErrors>) -> Void)
    func createPost(date: String, text: String, image: UIImage?, for user: String, completion: @escaping (Result<EachPost, Error>) -> Void)
    func addComment(mainUser: String, text: String, documentID: String, commentor: String, completion: @escaping (Result<Comment, Error>) -> Void)
    func getComments(post: String, user: String, completion: @escaping (Result<[Comment], Error>) -> Void)
    func addAnswerToComment(postID: String, user: String, commentID: String, answer: Answer, completion: @escaping (Result<Answer, Error>) -> Void)
    func getAnswers(post: String, comment: String, user: String, completion: @escaping (Result<[Answer], Error>) -> Void)
    func saveIntoFavourites(post: EachPost, for user: String) 
    func getDocLink(for id: String, user: String) -> String
    func disableCommentaries(id: String, user: String)
    func addDocToArchives(post: EachPost, user: String, completion: @escaping (Result<EachPost, Error>) -> Void)
    func addSnapshotListenerToPosts(for user: String, completion: @escaping (Result<[EachPost], Error>) -> Void)
    func removeListenerForPosts()
    func addSnapshotListenerToCurrentPost(docID: String, userID: String, completion: @escaping (Result<EachPost, Error>) -> Void)
    func removeListenerForCurrentPost()
    func fetchFavourites(user: String, completion: @escaping (Result<[EachPost], Error>) -> Void)
    func pinPost(user: String, docID: String)
    func addSnapshotListenerToFavourites(for user: String, completion: @escaping (Result<[EachPost], Error>) -> Void)
    func removeListenerForFavourites()
    func incrementLikes(user: String, mainUser: String, post: String)
    func decrementLikes(user: String, mainUser: String, post: String)
    func getNumberOfLikesInpost(user: String, post: String, completion: @escaping (Result <[Like], Error>) -> Void)
    func fetchArchives(user: String, completion: @escaping(Result<[EachPost], Error>) -> Void)
    func deleteDocument(docID: String, user: String, completion: @escaping (Result<Bool, Error>) -> Void)
    func removeSubscribtion(sub: String, for user: String)
    func saveToBookMarks(mainUser: String, user: String, post: EachPost)
    func fetchBookmarkedPosts(user: String, completion: @escaping (Result<[BookmarkedPost], Error>) -> Void)
    func removeFromFavourites(user: String, post: EachPost)

    // Функции для работы с изображением
    func saveImageIntoStorage(urlLink: StorageReference, photo: UIImage, completion: @escaping (Result <URL, Error>) -> Void)
    func saveImageIntoPhotoAlbum(image: String, user: String)
    func fetchImagesFromStorage(user: String, completion: @escaping (Result <[String:[UIImage]], Error>) -> Void)
}


final class FireStoreService: FireStoreServiceProtocol {

    var postListner: ListenerRegistration?

    var userListner: ListenerRegistration?

    var currentPostListner: ListenerRegistration?

    var favouritesListener: ListenerRegistration?

    static let shared = FireStoreService()

    private init() {}

    func addSnapshotListenerToUser(for user: String, completion: @escaping (Result<FirebaseUser, Error>) -> Void) {
        self.userListner?.remove()
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
                    completion(.failure(error))
                }
            }
        })
    }

    func removeListenerForUser() {
        self.userListner?.remove()
    }

    func addSnapshotListenerToPosts(for user: String, completion: @escaping (Result<[EachPost], Error>) -> Void) {
        self.postListner?.remove()
        let ref =  Firestore.firestore().collection("Users").document(user).collection("posts")
        var updatedArray: [EachPost] = []
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
                        do {
                            let post = try  document.data(as: EachPost.self)
                            updatedArray.append(post)
                        } catch {
                            completion(.failure(error))
                        }
                    }
                    completion(.success(updatedArray))
                }
            }
        }
    }

    func addSnapshotListenerToFavourites(for user: String, completion: @escaping (Result<[EachPost], Error>) -> Void) {
        self.favouritesListener?.remove()
        let ref =  Firestore.firestore().collection("Users").document(user).collection("Favourites")
        var updatedArray: [EachPost] = []
        self.favouritesListener = ref.addSnapshotListener { snapshot, error in
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
                        do {
                            let post = try  document.data(as: EachPost.self)
                            updatedArray.append(post)
                        } catch {
                            completion(.failure(error))
                        }
                    }
                    completion(.success(updatedArray))
                }
            }
        }
    }

    func removeListenerForFavourites() {
        favouritesListener?.remove()
    }

    func removeListenerForPosts() {
        postListner?.remove()
    }

    func addSnapshotListenerToCurrentPost(docID: String, userID: String, completion: @escaping (Result<EachPost, Error>) -> Void) {
        self.currentPostListner?.remove()
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
                    completion(.failure(error))
                }
            }
        }
    }

    func removeListenerForCurrentPost() {
        self.currentPostListner?.remove()
    }

    func getAllUsers(completion: @escaping (Result<[FirebaseUser], Error>) -> Void) {
        var usersArray: [FirebaseUser] = []
        let dbReference = Firestore.firestore().collection("Users")
        dbReference.getDocuments { snapshot, error in
            if let error = error {
                completion(.failure(error))
            }
            if let snapshot = snapshot {
                do {
                    for document in snapshot.documents {
                        let currentUser = try document.data(as: FirebaseUser.self)
                        usersArray.append(currentUser)
                    }
                } catch {
                    completion(.failure(error))
                }
            }
            completion(.success(usersArray))
        }
    }

    func incrementLikes(user: String, mainUser: String, post: String) {
        let date = Date.now
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-YYYY"
        let string = dateFormatter.string(from: date)
        let like = Like(documentID: mainUser, date: string)
        let dbReference = Firestore.firestore().collection("Users").document(user).collection("posts").document(post).collection("likes").document(mainUser)
        dbReference.setData(["date" : like.date!,
                             "documentID" : like.documentID!
                            ])
    }

    func decrementLikes(user: String, mainUser: String, post: String) {
        let dbReference = Firestore.firestore().collection("Users").document(user).collection("posts").document(post).collection("likes").document(mainUser)
        dbReference.delete()
    }

    func getNumberOfLikesInpost(user: String, post: String, completion: @escaping (Result <[Like], Error>) -> Void) {
        print("User that stored post: \(user), post: \(post)")
        let dbRef = Firestore.firestore().collection("Users").document(user).collection("posts").document(post).collection("likes")
        var likes: [Like] = []

        dbRef.getDocuments { snapshot, error in
            if let error = error {
                completion(.failure(error))
            }

            if let snapshot = snapshot {
                if !snapshot.documents.isEmpty {
                    for document in snapshot.documents {
                        do {
                            let like = try document.data(as: Like.self)
                            likes.append(like)
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
                            completion(.failure(error))
                        }
                    }
                } else {
                    completion(.success(likes))
                }
                completion(.success(likes))
            }
        }
    }

    func getUser(id: String, completion: @escaping (Result<FirebaseUser, AuthorisationErrors>) -> Void) {
        let dbReference = Firestore.firestore().collection("Users")
        dbReference.getDocuments {  snapshot, error in
            if let error = error {
                print("Error getting documents: \(error)")
                completion(.failure(.invalidCredential))
                return
            }

            guard let snapshot = snapshot else {
                completion(.failure(.invalidCredential))
                return
            }

            if snapshot.documents.isEmpty {
                completion(.failure(.userAlreadyExist))
                return
            }

            for document in snapshot.documents {
                if document.documentID == id {
                    do {
                        let currentUser = try document.data(as: FirebaseUser.self)
                        completion(.success(currentUser))
                        return
                    } catch let DecodingError.dataCorrupted(context) {
                        print(context)
                    } catch let DecodingError.keyNotFound(key, context) {
                        print("Key '\(key)' not found:", context.debugDescription)
                        print("codingPath:", context.codingPath)
                    } catch let DecodingError.valueNotFound(value, context) {
                        print("Value '\(value)' not found:", context.debugDescription)
                        print("codingPath:", context.codingPath)
                    } catch let DecodingError.typeMismatch(type, context) {
                        print("Type '\(type)' mismatch:", context.debugDescription)
                        print("codingPath:", context.codingPath)
                    } catch {
                        print("error: ", error)
                    }
                }
            }
            completion(.failure(.invalidCredential))
        }
    }

    func getPosts(sub: String, completion: @escaping (Result<[EachPost], PostErrors>) -> Void) {
        let refDB = Firestore.firestore().collection("Users").document(sub).collection("posts")
        var posts: [EachPost] = []

        refDB.getDocuments { snapshot, error in

            if error != nil {
                completion(.failure(.getError))
                return
            }

            guard let snapshot = snapshot else {
                completion(.failure(.getError))
                return
            }

            if snapshot.documents.isEmpty {
                completion(.success([]))
                return
            }

            for document in snapshot.documents {
                do {
                    let eachPost = try document.data(as: EachPost.self)
                    posts.append(eachPost)
                } catch {
                    print(error.localizedDescription)
                }
            }
            completion(.success(posts))
        }
    }

    func changeData(id: String, text: String, state: ChangeStates) {

        let ref = Firestore.firestore().collection("Users").document(id)

        switch state {
        case .name:
            ref.updateData(["name" : text])
        case .job:
            ref.updateData(["job" : text])
        case .identifier:
            ref.updateData(["identifier" : text])
        case .interests:
            ref.updateData(["interests" : text])
        case .contacts:
            ref.updateData(["contacts" : text])
        case .surname:
            ref.updateData(["surname" : text])
        case .storie:
            ref.updateData(["stories": FieldValue.arrayUnion([text])])
        case .dateOfBirth:
            ref.updateData(["dateOfBirth" : text])
        }
    }

    func fetchFavourites(user: String, completion: @escaping (Result<[EachPost], Error>) -> Void) {
        let ref = Firestore.firestore().collection("Users").document(user).collection("Favourites")
        var posts: [EachPost] = []
        ref.getDocuments { snapshot, error in
            if error != nil {
                return
            }

            if let snapshot = snapshot {
                if snapshot.documents.isEmpty {
                    return
                }
                for document in snapshot.documents {
                    do {
                        let eachPost = try document.data(as: EachPost.self)
                        posts.append(eachPost)
                    }  catch let DecodingError.dataCorrupted(context) {
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
                }
            }
            completion(.success(posts))
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

    func fetchImagesFromStorage(user: String, completion: @escaping (Result<[String: [UIImage]], Error>) -> Void) {
        let link = Storage.storage().reference().child("users").child(user).child("PhotoAlbum")
        var testDictionary: [String: [UIImage]] = [:]

        link.listAll { storageList, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let storageList = storageList else {
                completion(.success(testDictionary))
                return
            }

            let dispatchGroup = DispatchGroup()

            for folder in storageList.prefixes {
                dispatchGroup.enter()

                folder.listAll { folderStorageList, error in
                    if let folderStorageList = folderStorageList {
                        for document in folderStorageList.items {
                            dispatchGroup.enter()

                            document.getData(maxSize: 1 * 1024 * 1024) { data, error in
                                defer {
                                    dispatchGroup.leave()
                                }

                                if let error = error {
                                    completion(.failure(error))
                                    return
                                }

                                if let data = data, let decodedImage = UIImage(data: data) {
                                    if var existingImages = testDictionary[folder.name] {
                                        existingImages.append(decodedImage)
                                        testDictionary[folder.name] = existingImages
                                    } else {
                                        testDictionary[folder.name] = [decodedImage]
                                    }
                                }
                            }
                        }
                    }

                    dispatchGroup.leave()
                }
            }

            dispatchGroup.notify(queue: .main) {
                completion(.success(testDictionary))
            }
        }
    }

    func pinPost(user: String, docID: String) {
        let reft = Firestore.firestore().collection("Users").document(user).collection("posts").document(docID)
        reft.updateData(["isPinned" : true])
    }

    func createPost(date: String, text: String, image: UIImage?, for user: String, completion: @escaping (Result<EachPost, Error>) -> Void) {
        let postRef = Firestore.firestore().collection("Users").document(user).collection("posts")
        var fireStorePost = EachPost(text: "", image: "", likes: 0, commentaries: 0, date: date, isCommentariesEnabled: true, isPinned: false)

        if let image = image {
            let postStorageRef = Storage.storage().reference().child("users").child(user).child("posts").child(date).child(image.description)
            saveImageIntoStorage(urlLink: postStorageRef, photo: image) {  result in
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

        docReft.getDocuments {  snapshot, error in
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

    func saveIntoFavourites(post: EachPost, for user: String) {
        let docRef = Firestore.firestore().collection("Users").document(user).collection("Favourites")
        do {
            try docRef.addDocument(from: post)
        } catch {
            print(error.localizedDescription)
        }
    }

    func removeFromFavourites(user: String, post: EachPost) {
        let docRef = Firestore.firestore().collection("Users").document(user).collection("Favourites")
        docRef.getDocuments { snapshot, error in
            if error != nil {
                return
            }

            if let snapshot = snapshot {
                for document in snapshot.documents {
                    let documentText = document.data()["text"] as? String ?? "Cannot get Value"
                    print(documentText)
                    if documentText == post.text {
                        let documentRef = Firestore.firestore().collection("Users").document(user).collection("Favourites").document(document.documentID)
                        documentRef.delete()
                    }
                }
            }
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
        var newPost = post
print(user)
        if let image = post.image {
            let networkService = NetworkService()
            networkService.fetchImage(string: image) { [weak self] result in
                guard let self else { return }
                switch result {
                case .success(let image):
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
                                    print("Successfully archived")
                                    do {
                                        try archiveRef.addDocument(from: newPost)
                                        completion(.success(newPost))
                                    } catch {
                                        completion(.failure(error))
                                    }
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
            }
        }

        self.deleteDocument(docID: documentID, user: user) { [weak self] result in
            guard  self != nil else { return }
            switch result {
            case .success(_):
                print("Successfully archived")
                do {
                    try archiveRef.addDocument(from: newPost)
                    completion(.success(newPost))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let failure):
                completion(.failure(failure))
            }
        }

    }

    func deleteDocument(docID: String, user: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        let docRef = Firestore.firestore().collection("Users").document(user).collection("posts").document(docID)
        docRef.delete { error in
            if let error = error {
                completion(.failure(error))
            }
            print("Succesfully deleted")
            completion(.success(true))
        }
    }

    func removeSubscribtion(sub: String, for user: String) {
        let docRef = Firestore.firestore().collection("Users").document(user)
        docRef.updateData(["subscribtions" : FieldValue.arrayRemove([sub])])
        print("Successfully removed")
    }

    func removeSubscriber(sub: String, for user: String) {
        let docRef = Firestore.firestore().collection("Users").document(user)
        docRef.updateData(["subscribers" : FieldValue.arrayRemove([sub])])
        print("Successfully removed")
    }


    func fetchArchives(user: String, completion: @escaping(Result<[EachPost], Error>) -> Void) {
        var decodedDocuments: [EachPost] = []
        let link = Firestore.firestore().collection("Users").document(user).collection("Archive")
        link.getDocuments { snapshot, error in
            if let error = error {
                completion(.failure(error))
            }

            if let snapshot = snapshot {
                for document in snapshot.documents {
                    do {
                        let decodedDoc = try document.data(as: EachPost.self)
                        decodedDocuments.append(decodedDoc)
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
                completion(.success(decodedDocuments))
            }
        }
    }

    func saveToBookMarks(mainUser: String, user: String, post: EachPost) {
        guard let originalPostID = post.documentID else { return }
        let bookmarkedPost = BookmarkedPost(text: post.text, image: post.image, likes: post.likes, commentaries: post.commentaries, date: post.date, userHoldingPost: user, originaPostID: originalPostID)
        let link = Firestore.firestore().collection("Users").document(mainUser).collection("Bookmarks")
        do {
         try link.addDocument(from: bookmarkedPost)
        } catch {
            print(error.localizedDescription)
        }
    }

    func fetchBookmarkedPosts(user: String, completion: @escaping (Result<[BookmarkedPost], Error>) -> Void) {
        let link = Firestore.firestore().collection("Users").document(user).collection("Bookmarks")
        var decodedDocuments: [BookmarkedPost] = []

        link.getDocuments { snapshot, error in
            if let error = error {
                completion(.failure(error))
            }

            if let snapshot = snapshot {
                print("Count: \(snapshot.documents.count)")
                for document in snapshot.documents {
                    do {
                        let decodedDoc = try document.data(as: BookmarkedPost.self)
                        decodedDocuments.append(decodedDoc)
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
            completion(.success(decodedDocuments))
        }
    }

    func addReportToUser(user: String, text: String) {
        let refDB = Firestore.firestore().collection("Users").document(user)
        refDB.updateData(["report" : FieldValue.arrayUnion([text])])
    }
}


