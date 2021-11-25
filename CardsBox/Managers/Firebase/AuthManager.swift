//
//  AuthManager.swift
//  CardsBox
//
//  Created by Alexander Malygin on 11/9/21.
//

import Foundation
import Combine
import FirebaseAuth

protocol AuthManagerProtocol {
    func registration(user: RegisterModel) -> Future<Void, StorageError>
    func login(user: RegisterModel) -> Future<Void, StorageError>
}

final class AuthManager: AuthManagerProtocol {
    //Properties
    private let auth = Auth.auth()
    private var cancellable = Set<AnyCancellable>()
    
    //Protocols
    private let storageManager: StorageManagerProtocol
    private let firestoreManager: FirestoreManagerProtocol
    private var dataManager: DataManagerProtocol
    
    init(storageManager: StorageManagerProtocol, firestoreManager: FirestoreManagerProtocol, dataManager: DataManagerProtocol) {
        self.storageManager = storageManager
        self.firestoreManager = firestoreManager
        self.dataManager = dataManager
    }

    func registration(user: RegisterModel) -> Future<Void, StorageError> {
        return Future<Void, StorageError> { [weak self] promise in
            guard let self = self,
                  let email = user.email,
                  let password = user.password
            else { return promise(.failure(.errorWithUserData)) }
            
            let userProfile = UserProfileModel()
            let group = DispatchGroup()
            
            self.auth.createUser(withEmail: email, password: password) { result, error in
                guard error == nil else { return promise(.failure(.message(error?.localizedDescription ?? ""))) }
                if let id = self.auth.currentUser?.uid {
                    user.id = id
                    userProfile.id = id
                    userProfile.email = user.email
                    userProfile.userName = user.userName
                }
                
                if user.avatar != nil {
                    group.enter()
                    self.storageManager.uploadImage(image: user.avatar, path: "avatars/\(user.id ?? "")")
                        .sink { completion in
                            switch completion {
                            case .finished: break
                                case let .failure(error): promise(.failure(error)) }
                        } receiveValue: { url in
                            userProfile.avatar = url.absoluteString
                            group.leave()
                        }.store(in: &self.cancellable)
                }
                
                group.notify(queue: .main) {
                    self.firestoreManager.saveProfile(user: userProfile)
                        .sink(receiveCompletion: { completion in
                            switch completion {
                            case .finished: break
                                case let .failure(error): promise(.failure(error)) }
                        }, receiveValue: { _ in
                            promise(.success(()))
                            self.dataManager.userProfile = userProfile
                        }).store(in: &self.cancellable)
                }
            }
        }
    }
    
    func login(user: RegisterModel) -> Future<Void, StorageError> {
        return Future<Void, StorageError> { [weak self] promise in
            guard let self = self,
                  let email = user.email,
                  let password = user.password
            else { return promise(.failure(.errorWithUserData)) }
            
            self.auth.signIn(withEmail: email, password: password) { result, error in
                if error == nil, let result = result {
                    self.dataManager.userProfile = UserProfileModel(id: result.user.uid, userName: nil, email: email, avatar: nil)
                    promise(.success(()))
                } else {
                    promise(.failure(.userNotFound))
                }
            }
        }
    }
}
