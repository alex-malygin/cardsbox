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
    @Published var imageURL = URL(string: "")
    
    private var cancellable = Set<AnyCancellable>()
    
    private var dataManager: DataManagerProtocol
    
    init(dataManager: DataManagerProtocol) {
        self.dataManager = dataManager
        self.profile = dataManager.userProfile
        self.imageURL = URL(string: profile?.avatar ?? "")
    }
    
    func logout() {
        try? Auth.auth().signOut()
        dataManager.userProfile = nil
        dataManager.lastActiveDate = 0
    }
}
