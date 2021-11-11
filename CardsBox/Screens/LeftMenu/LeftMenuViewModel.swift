//
//  LeftMenuViewModel.swift
//  CardsBox
//
//  Created by Alexander Malygin on 11/8/21.
//

import Foundation
import Combine
import FirebaseAuth

final class LeftMenuViewModel: ObservableObject {
    @Published var profile: UserProfileModel?
    @Published var image = UIImage(named: "avatar") ?? UIImage()
    
    private var cancellable = Set<AnyCancellable>()
    
    init() {
 
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
