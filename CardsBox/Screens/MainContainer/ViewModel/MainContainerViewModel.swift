//
//  MainContainerViewModel.swift
//  CardsBox
//
//  Created by Alexander Malygin on 11/9/21.
//

import Foundation
import Combine
import FirebaseAuth

final class MainContainerViewModel: ObservableObject {
    private var firestoreManager: FirestoreManagerProtocol
    
    init(firestoreManager: FirestoreManagerProtocol) {
        self.firestoreManager = firestoreManager
        firestoreManager.getProfile()
    }
}

class MainContentViewModel: ObservableObject {
    @Published var isLogin = Auth.auth().currentUser != nil
    
    private var dataManager: DataManagerProtocol
    
    init(dataManager: DataManagerProtocol) {
        self.dataManager = dataManager
    }
    
    func logout() {
        try? Auth.auth().signOut()
        dataManager.userProfile = nil
        dataManager.lastActiveDate = 0
        isLogin = false
    }
}
