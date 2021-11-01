//
//  ProfileViewModel.swift
//  CardsBox
//
//  Created by Alexander Malygin on 10/29/21.
//

import Foundation
import FirebaseAuth

class ProfileViewModel: ObservableObject {
    @Published var isActive: Bool = false
    @Published var profile: UserProfileModel?
    
    
    init() {
        profile = DataManager.shared.userProfile
    }
    
    func logout() {
        try? Auth.auth().signOut()
        isActive = true
    }
}
