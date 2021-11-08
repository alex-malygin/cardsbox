//
//  DatabaseManager.swift
//  CardsBox
//
//  Created by Alexander Malygin on 11/6/21.
//

import Foundation
import FirebaseDatabase
import FirebaseAuth
import Combine

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
                            "avatar": user.avatar?.absoluteString] as [String: Any]
            
            self?.database.child("users/profile/\(userID)").updateChildValues(userData, withCompletionBlock: { error, refData in
                self?.getUserProfile(userID: userID)
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
            let avatarURL = URL(string: avatar)
            
            let user = UserProfileModel(id: userID, userName: username, email: email, avatar: avatarURL)
            
            self?.dataManager.userProfile = user
        })
    }
    
    func addCard(card: CardModel) -> Future<Bool, StorageError> {
        return Future<Bool, StorageError> { [weak self] promise in
            guard let userID = self?.dataManager.userProfile?.id else { return promise(.failure(.idNotFound))}
            
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
            guard let userID = self?.dataManager.userProfile?.id  else { return promise(.failure(.idNotFound))}
            
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
    
    func deleteCard(cardID: String?) -> Future<Bool, StorageError> {
        return Future<Bool, StorageError> { [weak self] promise in
            guard let cardID = cardID, let userID = self?.dataManager.userProfile?.id else { return promise(.failure(.idNotFound))}

            self?.database.child("db/cards/\(userID)/\(cardID)").removeValue(completionBlock: { error, refData in
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
        return card.eraseToAnyPublisher()
    }
}
