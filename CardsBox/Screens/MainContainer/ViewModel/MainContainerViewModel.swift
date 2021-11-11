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
        FirestoreManager.shared.getProfile()
    }
}