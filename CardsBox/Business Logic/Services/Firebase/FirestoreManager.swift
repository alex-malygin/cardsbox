//
//  FirestoreManager.swift
//  CardsBox
//
//  Created by Alexander Malygin on 11/6/21.
//

import Firebase
import Combine
import FirebaseFirestore
import FirebaseAuth

protocol FirestoreServiceProtocol {
    func saveProfile(user: UserProfileModel) -> Future<Void, StorageError>
    func getProfile()
    func updateProfile(profileInfo: ProfileInfo?) -> Future<Void, StorageError>
    func addCard(model: CardModel) -> Future<Void, StorageError>
    func updateCard(model: CardModel) -> Future<Void, StorageError>
    func deleteCard(id: String)
    func getCards() -> AnyPublisher<[CardModel]?, StorageError>
}

final class FirestoreManager: FirestoreServiceProtocol {
    private var cancellable = Set<AnyCancellable>()
    private let dataManager = DataManager.shared
    private let auth = Auth.auth()
    private let db = Firestore.firestore()
    
    let storageService: StorageServiceProtocol
    
    init(storageService: StorageServiceProtocol = StorageManager()) {
        self.storageService = storageService
    }
    
    func saveProfile(user: UserProfileModel) -> Future<Void, StorageError> {
        return Future<Void, StorageError> { [weak self] promise in
            guard let userID = user.id else { return promise(.failure(.idNotFound))}
            self?.db.collection(Keys.users.rawValue).document("\(userID)").setData(user.userDictionary, completion: { error in
                if error == nil {
                    promise(.success(()))
                } else {
                    promise(.failure(.profileNotSave))
                }
            })
        }
    }
    
    func getProfile() {
        guard let userID = Auth.auth().currentUser?.uid else { return }
        db.collection(Keys.users.rawValue).document("\(userID)").getDocument(completion: { document, error in
            if let document = document, document.exists, let userData = document.data() {
                do {
                    let user = try? JSONDecoder().decode(UserProfileModel.self, from: JSONSerialization.data(withJSONObject: userData))
                    DataManager.shared.userProfile = user
                }
            } else {
                print("Document does not exist")
            }
        })
    }
    
    func updateProfile(profileInfo: ProfileInfo?) -> Future<Void, StorageError> {
        return Future<Void, StorageError> { [weak self] promise in
            guard let self = self, let profileInfo = profileInfo, let userID = profileInfo.id else { return promise(.failure(.idNotFound))}
            let group = DispatchGroup()
            
            if profileInfo.selectedImage != nil {
                group.enter()
                self.storageService.uploadImage(image: profileInfo.selectedImage, path: "avatars/\(userID)")
                    .sink(receiveCompletion: { completion in
                        switch completion {
                        case .finished: break
                            case let .failure(error): promise(.failure(error)) }
                    }, receiveValue: { url in
                        profileInfo.url = url.absoluteString
                        group.leave()
                    }).store(in: &self.cancellable)
            }
            
            group.notify(queue: .main) {
                self.db.collection(Keys.users.rawValue).document(userID).updateData(profileInfo.userDictionary, completion: { error in
                    if error == nil {
                        promise(.success(()))
                        self.getProfile()
                    } else {
                        promise(.failure(.profileNotSave))
                    }
                })
            }
        }
    }
    
    func addCard(model: CardModel) -> Future<Void, StorageError> {
        return Future<Void, StorageError> { [weak self] promise in
            guard let userID = Auth.auth().currentUser?.uid else { return  promise(.failure(.idNotFound)) }
            
            self?.db.collection(Keys.cards.rawValue).document(userID)
                .setData(model.cardDictionary, merge: true, completion: { error in
                    if error == nil {
                        promise(.success(()))
                    } else {
                        promise(.failure(.cardNotSave))
                    }
                })
        }
    }
    
    func updateCard(model: CardModel) -> Future<Void, StorageError> {
        return Future<Void, StorageError> { [weak self] promise in
            guard let userID = Auth.auth().currentUser?.uid else { return  promise(.failure(.idNotFound)) }
            
            self?.db.collection(Keys.cards.rawValue)
                .document(userID)
                .updateData(model.cardDictionary, completion: { error in
                    if error == nil {
                        promise(.success(()))
                    } else {
                        promise(.failure(.cardNotSave))
                    }
                })
        }
    }
    
    func deleteCard(id: String) {
        guard let userID = Auth.auth().currentUser?.uid else { return }
        
        db.collection(Keys.cards.rawValue)
            .document(userID)
            .updateData([id: FieldValue.delete()])
    }
    
    func getCards() -> AnyPublisher<[CardModel]?, StorageError> {
        let subject = PassthroughSubject<[CardModel]?, StorageError>()
        
        guard let userID = Auth.auth().currentUser?.uid else {
            return Just([])
                .setFailureType(to: StorageError.self)
                .eraseToAnyPublisher()
        }
        
        db.collection(Keys.cards.rawValue)
            .document(userID)
            .addSnapshotListener({ documentSnapshot, error in
                if error == nil, let snapshot = documentSnapshot {
                    
                    let cards = snapshot.data()?.compactMap({
                        try? JSONDecoder().decode(CardModel.self, from: JSONSerialization.data(withJSONObject: $0.value))
                    })
                    
                    debugPrint("[💳] cards", cards as Any)
                    subject.send(cards)
                    
                } else {
                    subject.send([])
                    debugPrint("[‼️] Error get cards", error?.localizedDescription as Any)
                }
            })
        return subject.eraseToAnyPublisher()
    }
}

extension FirestoreManager {
    private enum Keys: String {
        case users
        case cards
    }
}

enum StorageError: Error {
    case uploadAvatarError
    case userNotFound
    case downloadImageError
    case errorWithUserData
    case profileNotSave
    case cardNotSave
    case cardNotParse
    case cardsNotFound
    case idNotFound
    case emailNotUpdate
    case message(String)
    
    var errorMessage: String? {
        switch self {
        case .uploadAvatarError:
            return "Failed to upload avatar 😔"
        case .userNotFound:
            return "This user will not find 😔"
        case .downloadImageError:
            return "Failed to download image 😔"
        case .errorWithUserData:
            return "Some error with user data 😔"
        case .profileNotSave:
            return "Failed to save this profile 😔"
        case .cardNotSave:
            return "Failed to save card 😔"
        case .cardNotParse:
            return "Failed to get data 😔"
        case .cardsNotFound:
            return "Failed to get data for this card 😔"
        case .idNotFound:
            return "Id was not found 😔"
        case .emailNotUpdate:
            return "Email has not been updated 😔"
        case let .message(error): return error
        }
    }
}
