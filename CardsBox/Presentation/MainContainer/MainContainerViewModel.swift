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
    
    init() {
        ServiceConfigurator.makeFirestoreService().getProfile()
    }
}

class MainContentViewModel: ObservableObject {
    @Published var isLogin = Auth.auth().currentUser != nil
    
    init() { }
}
