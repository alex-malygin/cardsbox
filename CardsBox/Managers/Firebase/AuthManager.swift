//
//  AuthManager.swift
//  CardsBox
//
//  Created by Alexander Malygin on 11/9/21.
//

import Foundation
import Combine
import FirebaseAuth

final class AuthManager {
    static let shared = AuthManager()
    private init() { }
    
    private let auth = Auth.auth()
    private let firestore = FirestoreManager.shared
    private let storage = StorageManager.shared
    private var cancellable = Set<AnyCancellable>()
    
    func registration(user: RegisterModel) -> Future<Void, StorageError> {
        return Future<Void, StorageError> { [weak self] promise in
            guard let self = self,
                  let email = user.email,
                  let password = user.password
            else { return promise(.failure(.errorWithUserData)) }
            
            let userProfile = UserProfileModel()
            let group = DispatchGroup()
            
            Auth.auth().createUser(withEmail: email, password: password) { result, error in
                guard error == nil else { return promise(.failure(.message(error?.localizedDescription ?? ""))) }
                if let id = self.auth.currentUser?.uid {
                    user.id = id
                    userProfile.id = id
                    userProfile.email = user.email
                    userProfile.userName = user.userName
                }
                
                group.enter()
                self.storage.uploadImage(image: user.avatar, path: "avatars/\(user.id ?? "")")
                    .sink { completion in
                        switch completion {
                        case .finished: break
                            case let .failure(error): promise(.failure(error)) }
                    } receiveValue: { url in
                        userProfile.avatar = url
                        group.leave()
                    }.store(in: &self.cancellable)
                
                group.notify(queue: .main) {
                    self.firestore.saveProfile(user: userProfile)
                        .sink(receiveCompletion: { completion in
                            switch completion {
                            case .finished: break
                                case let .failure(error): promise(.failure(error)) }
                        }, receiveValue: { _ in
                            promise(.success(()))
                            DataManager.shared.userProfile = userProfile
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
                    DataManager.shared.userProfile = UserProfileModel(id: result.user.uid, userName: nil, email: email, avatar: nil)
                    promise(.success(()))
                } else {
                    promise(.failure(.userNotFound))
                }
            }
        }
    }
}
