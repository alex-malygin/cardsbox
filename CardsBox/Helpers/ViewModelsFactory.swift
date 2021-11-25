//
//  ViewModelsFactory.swift
//  CardsBox
//
//  Created by Alexander Malygin on 11/25/21.
//

import Foundation
import SwiftUI

class ViewModelsFactory: ObservableObject {
    private let dataManager = DataManager.shared
    private let storageManager = StorageManager()
    private let authManager: AuthManager
    private let firestoreManager: FirestoreManager
    
    init() {
        self.firestoreManager = FirestoreManager(dataManager: dataManager,
                                                 storageManager: storageManager)
        self.authManager = AuthManager(storageManager: storageManager,
                                       firestoreManager: firestoreManager,
                                       dataManager: dataManager)
    }
    
    func makeLoginViewModel() -> LoginViewModel {
        return LoginViewModel(dataManager: dataManager, authManager: authManager)
    }
    
    func makeSignUpViewModel() -> SignUpViewModel {
        return SignUpViewModel(dataManager: dataManager, authManager: authManager)
    }
    
    func makeMainContentViewModel() -> MainContentViewModel {
        return MainContentViewModel(dataManager: dataManager)
    }
    
    func makeMainContainerViewModel() -> MainContainerViewModel {
        return MainContainerViewModel(firestoreManager: firestoreManager)
    }
    
    func makeLeftMenuViewModel() -> LeftMenuViewModel {
        return LeftMenuViewModel(dataManager: dataManager)
    }
    
    func makeHomeViewModel() -> HomeViewModel {
        return HomeViewModel(firestoreManager: firestoreManager)
    }
    
    func makeSettingsViewModel() -> SettingsViewModel {
        return SettingsViewModel(dataManager: dataManager, firestoreManager: firestoreManager)
    }
    
    func makeCardDetailViewModel() -> CardDetailViewModel {
        return CardDetailViewModel(firestoreManager: firestoreManager)
    }
}
