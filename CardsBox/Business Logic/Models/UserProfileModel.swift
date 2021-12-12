//
//  SignUpModel.swift
//  CardsBox
//
//  Created by Alexander Malygin on 10/28/21.
//

import Foundation
import UIKit

class UserProfileModel: Codable {
    var id: String?
    var userName: String?
    var email: String?
    var avatar: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case userName = "user_name"
        case email
        case avatar
    }
    
    init(id: String?, userName: String?, email: String?, avatar: String?) {
        self.id = id
        self.userName = userName
        self.email = email
        self.avatar = avatar
    }
    
    init() {
        self.id = nil
        self.userName = nil
        self.email = nil
        self.avatar = nil
    }
    
    var userDictionary: [String: Any]   {
        return [
            "id": id ?? "",
            "user_name": userName ?? "",
            "email": email ?? "",
            "avatar": avatar ?? ""
        ]
    }
}

extension UserProfileModel {
    static func fake() -> Self {
        return UserProfileModel(id: "123",
                                userName: "Test fake",
                                email: "fakeemail@g.com",
                                avatar: nil) as! Self
    }
}
