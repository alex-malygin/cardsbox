//
//  ServiceConfigurator.swift
//  CardsBox
//
//  Created by Alexander Malygin on 12/11/21.
//

import Foundation

protocol ServiceConfiguratorProtocol {
    static func makeAuthService() -> AuthManager
    static func makeFirestoreService() -> FirestoreManager
    static func makeStorageService() -> StorageManager
}

final class ServiceConfigurator: ServiceConfiguratorProtocol {
    public static func makeAuthService() -> AuthManager {
        return AuthManager(firestoreService: ServiceConfigurator.makeFirestoreService(),
                           storageService: ServiceConfigurator.makeStorageService())
    }
    
    public static func makeFirestoreService() -> FirestoreManager {
        return FirestoreManager(storageService: makeStorageService())
    }
    
    public static func makeStorageService() -> StorageManager {
        return StorageManager()
    }
}
