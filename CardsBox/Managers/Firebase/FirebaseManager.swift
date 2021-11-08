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

enum StorageError: Error {
    case uploadAvatarError
    case userNotFound
    case downloadImageError
    case errorWithUserData
    case profileNotSave
    case idNotFound
    case message(String)
}

final class FirebaseManager {
    static let shared = FirebaseManager()
    private let database = DatabaseManager.shared
    private let dataManager = DataManager.shared
    private var cancellable = Set<AnyCancellable>()
    
    func registration(user: UserProfileModel, avatar: UIImage?) -> Future<Bool, StorageError> {
        return Future<Bool, StorageError> { [weak self] promise in
            guard let self = self,
                  let email = user.email,
                  let password = user.password
            else { return promise(.failure(.errorWithUserData)) }
            
            Auth.auth().createUser(withEmail: email, password: password) { result, error in
                guard error == nil else { return promise(.failure(.message(error?.localizedDescription ?? ""))) }
                user.id = Auth.auth().currentUser?.uid
                
                if avatar != nil, let avatar = avatar {
                    StorageManager.shared.uploadUserAvatar(image: avatar, path: "avatars/\(user.id ?? "")").sink { completion in
                        switch completion {
                        case .finished: break
                        case let .failure( error):
                            return promise(.failure(error))
                        }
                    } receiveValue: { avatar in
                        user.avatar = avatar
                        self.dataManager.userProfile = user
                        
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
                    self?.dataManager.userProfile?.id = Auth.auth().currentUser?.uid
                    self?.database.getUserProfile(userID: Auth.auth().currentUser?.uid)
                    return promise(.success(error == nil))
                } else {
                    return promise(.failure(.userNotFound))
                }
            }
        }
    }
    
    func updateAvatar(user: UserProfileModel, avatar: UIImage?) -> Future<Bool, StorageError> {
        return Future<Bool, StorageError> {[ weak self] promise in
            guard let self = self else { return promise(.failure(.uploadAvatarError))}
            if avatar != nil, let avatar = avatar {
                StorageManager.shared.uploadUserAvatar(image: avatar, path: "avatars/\(user.id ?? "")").sink { completion in
            
                } receiveValue: { avatar in
                    user.avatar = avatar
                    self.dataManager.userProfile = user
                    
                    self.database.updateUserProfile(user: user).sink { completion in
                        
                    } receiveValue: { success in
                        promise(.success(success))
                        self.database.updateUserProfile(user: user)
                    }.store(in: &self.cancellable)
                    
                }.store(in: &self.cancellable)
            }
        }
    }
}
