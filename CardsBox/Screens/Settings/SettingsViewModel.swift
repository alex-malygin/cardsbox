//
//  SettingsViewModel.swift
//  CardsBox
//
//  Created by Alexander Malygin on 11/5/21.
//

import Foundation
import Combine
import UIKit

final class SettingsViewModel: ObservableObject {
    @Published var profileInfo: ProfileInfo
    @Published var image = UIImage(named: "avatar") ?? UIImage()
    @Published var showLoader = false
    @Published var showAlert = false
    @Published var errorText = ""
    
    private var cancellable = Set<AnyCancellable>()
    private let userProfile = DataManager.shared.userProfile
    
    init() {
        self.profileInfo = ProfileInfo(id: userProfile?.id, userName: userProfile?.userName, email: userProfile?.email, selectedImage: nil, url: userProfile?.avatar)
    }
    
    func setNewImage(image: UIImage) {
        self.image = image
        self.profileInfo.selectedImage = image
    }
    
    func save() {
        showLoader = true
        FirestoreManager.shared.updateProfile(profileInfo: profileInfo)
            .sink { [weak self] completion in
                switch completion {
                case .finished: break
                case let .failure(error):
                    debugPrint("Error register", error)
                    self?.errorText = error.localizedDescription
                    self?.showAlert = true
                    self?.showLoader = false
                }
        } receiveValue: { [weak self] _ in
            self?.showLoader = false
        }.store(in: &cancellable)
    }
}

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
    
    var userDictionary: [String: Any]   {
        return [
            "id": id ?? "",
            "user_name": userName ?? "",
            "email": email ?? "",
            "avatar": url?.absoluteString ?? ""
        ]
    }
}
