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
    private var cancellable = Set<AnyCancellable>()
    
    func registration(user: UserProfileModel) {
        Auth.auth().createUser(withEmail: user.email!, password: user.password!) {[weak self] result, error in
            guard let self = self, error == nil else { return }
            user.id = Auth.auth().currentUser?.uid

            StorageManager.shared.uploadUserAvatar(image: user.avatarRef!, path: "avatars/\(user.id!)").sink { completion in
                switch completion {
                case .finished: break
                case .failure(_): break
                }
            } receiveValue: { avatar in
                user.avatar = avatar.absoluteString
                DatabaseManager.shared.saveProfile(user: user)
                    .sink { success in
                        debugPrint("createUser - \(success)")
                    }.store(in: &self.cancellable)
                
            }.store(in: &self.cancellable)
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
    
    func saveProfile(user: UserProfileModel) -> Future<Bool, Never> {
        return Future<Bool, Never> { [weak self] promise in
            
            let userData = ["id": user.id,
                            "userName": user.userName,
                            "email": user.email,
                            "avatar": user.avatar] as [String: Any]
            
            _ = self?.updateUserProfile(user: user)
            
            self?.database.child("users/profile/\(user.id!)").setValue(userData, withCompletionBlock: { error, refData in
                return promise(.success(error == nil))
            })
        }
    }
    
    func updateUserProfile(user: UserProfileModel) -> Future<Bool, Never> {
        return Future<Bool, Never> { [weak self] promise in
            
            self?.changeRequest?.displayName = user.userName
            self?.changeRequest?.photoURL = URL(string: user.avatar!)
            
            self?.changeRequest?.commitChanges(completion: { error in
                return promise(.success(error == nil))
            })
        }
    }
}


enum StorageError: Error {
    case uploadAvatarError, userNotFound, downloadImageError
}
