//
//  SignUpViewModel.swift
//  CardsBox
//
//  Created by Alexander Malygin on 10/28/21.
//

import Foundation
import Combine
import UIKit

class SignUpViewModel: ObservableObject {
    @Published var userModel = UserProfileModel()
    @Published var isActive = false
    
    private var cancellable = Set<AnyCancellable>()
    
    func registration() {
        let image = UIImage(named: "avatar")
        userModel.userName = "Alex"
        userModel.email = "limanka92@gmail.com"
        userModel.password = "qwerty1234"
        userModel.avatarRef = image
        
        FirebaseManager.shared.registration(user: userModel)
    
    }
}
