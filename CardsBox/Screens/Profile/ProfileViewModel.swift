//
//  ProfileViewModel.swift
//  CardsBox
//
//  Created by Alexander Malygin on 10/29/21.
//

import Foundation
import FirebaseAuth
import SwiftUI

class ProfileViewModel: ObservableObject {
    @Published var profile: UserProfileModel?
    @Published var image = UIImage(named: "avatar") ?? UIImage()
    
    init() {
        profile = DataManager.shared.userProfile
    }
    
    func setUserProfile() {
        profile = DataManager.shared.userProfile
    }
    
    func logout() {
        try? Auth.auth().signOut()
        DataManager.shared.userProfile = nil
        Router.showMain()
    }
}
