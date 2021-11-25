//
//  ProfileInfoModel.swift
//  CardsBox
//
//  Created by Alexander Malygin on 11/24/21.
//

import Foundation
import UIKit

class ProfileInfo {
    var id: String?
    var userName: String?
    var email: String?
    var password: String?
    var selectedImage: UIImage?
    var url: URL?
    
    init(id: String?, userName: String?, email: String?, selectedImage: UIImage?, url: URL?) {
        self.id = id
        self.userName = userName
        self.email = email
        self.selectedImage = selectedImage
        self.url = url
    }
    
    init(_ model: UserProfileModel?) {
        self.id = model?.id
        self.userName = model?.userName
        self.email = model?.email
        self.selectedImage = nil
        self.url = URL(string: model?.avatar ?? "")
    }
    
    var userDictionary: [String: Any]   {
        return [
            "id": id ?? "",
            "user_name": userName ?? "",
            "email": email ?? "",
            "avatar": url ?? ""
        ]
    }
}
