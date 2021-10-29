//
//  SignUpModel.swift
//  CardsBox
//
//  Created by Alexander Malygin on 10/28/21.
//

import Foundation
import UIKit
import Firebase

class UserProfileModel {
    var id: String?
    var userName: String?
    var email: String?
    var password: String?
    var avatar: String?
    var avatarRef: UIImage?
    
    init() {
        self.id = nil
        self.userName = nil
        self.email = nil
        self.password = nil
        self.avatar = nil
        self.avatarRef = nil
    }
    
    init(id: String, userName: String, email: String, password: String, avatar: String, avatarRef: UIImage) {
        self.id = id
        self.userName = userName
        self.email = email
        self.password = password
        self.avatar = avatar
        self.avatarRef = avatarRef
    }
    
    init(model: User) {
        self.id = model.uid
        self.userName = model.displayName
        self.email = model.email
        self.password = nil
        self.avatar = model.photoURL?.absoluteString
        self.avatarRef = nil
    }
    
}
