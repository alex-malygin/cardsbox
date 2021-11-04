//
//  SignUpModel.swift
//  CardsBox
//
//  Created by Alexander Malygin on 10/28/21.
//

import Foundation
import UIKit
import Firebase

class UserProfileModel: Codable {
    var id: String?
    var userName: String?
    var email: String?
    var password: String?
    var avatar: URL?
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case userName = "user_name"
        case email = "email"
        case password = "password"
        case avatar = "avatar"
    }
    
    init() {
        self.id = nil
        self.userName = nil
        self.email = nil
        self.password = nil
        self.avatar = nil
    }
    
    init?(model: User?) {
        self.id = model?.uid
        self.userName = model?.displayName
        self.email = model?.email
        self.password = nil
        self.avatar = model?.photoURL
    }
}
