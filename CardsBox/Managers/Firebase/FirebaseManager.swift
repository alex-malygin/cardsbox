//
//  FirebaseManager.swift
//  CardsBox
//
//  Created by Alexander Malygin on 10/28/21.
//

import Foundation
import UIKit
import Combine
import Firebase
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase

final class FirebaseManager {
    static let shared = FirebaseManager()
    private let database = DatabaseManager.shared
    private let dataManager = DataManager.shared
    private var cancellable = Set<AnyCancellable>()
    
    func registration(user: UserProfileModel) -> Future<Bool, StorageError> {
        return Future<Bool, StorageError> { [weak self] promise in
            guard let self = self,
                  let email = user.email,
                  let password = user.password
            else { return promise(.failure(.errorWithUserData)) }
            
            Auth.auth().createUser(withEmail: email, password: password) { result, error in
                guard error == nil else { return promise(.failure(.message(error?.localizedDescription ?? ""))) }
                user.id = Auth.auth().currentUser?.uid
                
                if user.avatarRef != nil, let avatar = user.avatarRef {
                    StorageManager.shared.uploadUserAvatar(image: avatar, path: "avatars/\(user.id ?? "")").sink { completion in
                        switch completion {
                        case .finished: break
                        case let .failure( error):
                            return promise(.failure(error))
                        }
                    } receiveValue: { avatar in
                        user.avatar = avatar.absoluteString
                        self.dataManager.userProfile = user
                        self.dataManager.userID = user.id
                        
                        DatabaseManager.shared.saveProfile(user: user)
                            .sink { completion in
                                switch completion {
                                case .finished: break
                                case let .failure( error):
                                    return promise(.failure(error))
                                }
                            } receiveValue: { success in
                                promise(.success(success))
                            }.store(in: &self.cancellable)
                    }.store(in: &self.cancellable)
                } else {
                    self.dataManager.userProfile = user
                    self.dataManager.userID = user.id
                    
                    DatabaseManager.shared.saveProfile(user: user)
                        .sink { completion in
                            switch completion {
                            case .finished: break
                            case let .failure( error):
                                return promise(.failure(error))
                            }
                        } receiveValue: { success in
                            promise(.success(success))
                        }.store(in: &self.cancellable)
                }
            }
        }
    }
    
    
    func login(user: UserProfileModel) -> Future<Bool, StorageError> {
        return Future<Bool, StorageError> { [weak self] promise in
            guard let email = user.email,
                  let password = user.password
            else { return promise(.failure(.errorWithUserData)) }
            
            Auth.auth().signIn(withEmail: email, password: password) { result, error in
                if error == nil {
                    self?.dataManager.userID = Auth.auth().currentUser?.uid
                    self?.database.getUserProfile(userID: Auth.auth().currentUser?.uid)
                    return promise(.success(error == nil))
                } else {
                    return promise(.failure(.userNotFound))
                }
            }
        }
    }
}

final class StorageManager {
    static let shared = StorageManager()
    private var cancellable = Set<AnyCancellable>()
    private let storage = Storage.storage().reference()
    
    func uploadUserAvatar(image: UIImage, path: String) -> Future<URL, StorageError> {
        return Future<URL, StorageError> { [weak self] promise in
            guard let self = self,
                  let imageData = image.jpegData(compressionQuality: 0.9)
            else { return promise(.failure(.userNotFound))}
            
            let metaDataStorage = StorageMetadata()
            metaDataStorage.contentType = "image/jpg"
            
            self.storage.child(path).putData(imageData, metadata: metaDataStorage, completion: { metaData, error in
                guard error == nil else { return promise(.failure(.uploadAvatarError)) }
                
                self.downloadImage(path: path).sink { completion in
                    return promise(.failure(.downloadImageError))
                } receiveValue: { imageURL in
                    promise(.success(imageURL))
                }.store(in: &self.cancellable)
            })
        }
    }
    
    func downloadImage(path: String) -> Future<URL, StorageError> {
        return Future<URL, StorageError> { [weak self] promise in
            self?.storage.child(path).downloadURL(completion: { imageURL, error in
                guard error == nil, let imageURL = imageURL else { return promise(.failure(.downloadImageError)) }
                return promise(.success(imageURL))
            })
        }
    }
}

final class DatabaseManager {
    static let shared = DatabaseManager()
    private var cancellable = Set<AnyCancellable>()
    private let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
    private let database = Database.database().reference()
    private let dataManager = DataManager.shared
    
    func saveProfile(user: UserProfileModel) -> Future<Bool, StorageError> {
        return Future<Bool, StorageError> { [weak self] promise in
            guard let userID = user.id else { return promise(.failure(.idNotFound)) }
            
            let userData = ["id": userID,
                            "userName": user.userName,
                            "email": user.email,
                            "avatar": user.avatar] as [String: Any]
            
            self?.database.child("users/profile/\(userID)").setValue(userData, withCompletionBlock: { error, refData in
                return promise(.success(error == nil))
            })
        }
    }
    
    @discardableResult
    func updateUserProfile(user: UserProfileModel) -> Future<Bool, StorageError> {
        return Future<Bool, StorageError> { [weak self] promise in
            guard let userID = user.id else { return promise(.failure(.idNotFound)) }
            
            let userData = ["id": userID,
                            "userName": user.userName,
                            "email": user.email,
                            "avatar": user.avatar] as [String: Any]
            
            self?.database.child("users/profile/\(userID)").updateChildValues(userData, withCompletionBlock: { error, refData in
                return promise(.success(error == nil))
            })
        }
    }
    
    func getUserProfile(userID: String?) {
        guard let userID = userID else { return }
        
        self.database.child("users/profile/\(userID)").getData(completion: { [weak self] error, snapshot in
            guard error == nil else { return }
            
            let value = snapshot.value as? NSDictionary
            let username = value?["userName"] as? String ?? ""
            let email = value?["email"] as? String ?? ""
            let avatar = value?["avatar"] as? String ?? ""
            
            let user = UserProfileModel(id: userID, userName: username, email: email, password: nil, avatar: avatar, avatarRef: nil)
            
            self?.dataManager.userProfile = user
            self?.dataManager.userID = userID
        })
    }
    
    func addCard(card: CardModel) -> Future<Bool, StorageError> {
        return Future<Bool, StorageError> { [weak self] promise in
            guard let userID = self?.dataManager.userID else { return promise(.failure(.idNotFound))}
            
            let cardData = ["id": card.id,
                            "userName": card.userName,
                            "cardNumber": card.cardNumber,
                            "cardType": card.cardType,
                            "cardBG": card.cardBG] as [String: Any]
            
            self?.database.child("db/cards/\(userID)/\(card.id)").setValue(cardData, withCompletionBlock: { error, refData in
                if error == nil {
                    return promise(.success(error == nil))
                } else {
                    return promise(.failure(.errorWithUserData))
                }
            })
        }
    }
    
    func updateCard(card: CardModel) -> Future<Bool, StorageError> {
        return Future<Bool, StorageError> { [weak self] promise in
            guard let userID = self?.dataManager.userID else { return promise(.failure(.idNotFound))}
            
            let cardData = ["id": card.id,
                            "userName": card.userName,
                            "cardNumber": card.cardNumber,
                            "cardType": card.cardType,
                            "cardBG": card.cardBG] as [String: Any]
            
            self?.database.child("db/cards/\(userID)/\(card.id)").updateChildValues(cardData, withCompletionBlock: { error, refData in
                if error == nil {
                    return promise(.success(error == nil))
                } else {
                    return promise(.failure(.errorWithUserData))
                }
            })
        }
    }
    
    func getCards(userID: String) -> AnyPublisher<[CardModel], StorageError> {
        let card = PassthroughSubject<[CardModel], StorageError>()
        
        if let userID = dataManager.userID  {
            self.database.child("db/cards/\(userID)").observe(.value) { snapshot in
                
                var cards = [CardModel]()
                
                for child in snapshot.children {
                    let snapshot = child as? DataSnapshot
                    let value = snapshot?.value as? [String: AnyObject]

                    let id = value?["id"] as? String ?? ""
                    let userName = value?["userName"] as? String ?? ""
                    let cardNumber = value?["cardNumber"] as? String ?? ""
                    let cardType = value?["cardType"] as? String ?? ""
                    let cardBG = value?["cardBG"] as? String ?? ""
                    
                    let cardModel = CardModel(id: id,
                                              cardType: cardType,
                                              userName: userName,
                                              cardNumber: cardNumber,
                                              bgType: BackgroundCardType(rawValue: cardBG) ?? .default)
                    
                    cards.append(cardModel)
                }
                card.send(cards)
            }
        }
        return card.eraseToAnyPublisher()
    }
}


enum StorageError: Error {
    case uploadAvatarError
    case userNotFound
    case downloadImageError
    case errorWithUserData
    case profileNotSave
    case idNotFound
    case message(String)
}
