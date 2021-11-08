//
//  StorageManager.swift
//  CardsBox
//
//  Created by Alexander Malygin on 11/6/21.
//

import Foundation
import FirebaseStorage
import FirebaseAuth
import Combine

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
