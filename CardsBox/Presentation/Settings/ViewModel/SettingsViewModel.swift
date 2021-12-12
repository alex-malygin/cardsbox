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
    @Published var alertType: AlertType = .error
    
    private var cancellable = Set<AnyCancellable>()
    private let userProfile = DataManager.shared.userProfile
    private let firestoreService: FirestoreServiceProtocol
    
    enum AlertType {
        case error
        case disableField
    }
    
    init(firestoreService: FirestoreServiceProtocol) {
        self.firestoreService = firestoreService
        self.profileInfo = ProfileInfo(id: userProfile?.id, userName: userProfile?.userName, email: userProfile?.email, selectedImage: nil, url: userProfile?.avatar)
    }
    
    func showDisabledAlert() {
        errorText = "Not available in this version"
        alertType = .disableField
        showAlert = true
    }
    
    func setNewImage(image: UIImage) {
        self.image = image
        self.profileInfo.selectedImage = image
    }
    
    func save() {
        showLoader = true
        firestoreService.updateProfile(profileInfo: profileInfo)
            .sink { [weak self] completion in
                switch completion {
                case .finished: break
                case let .failure(error):
                    debugPrint("Error register", error.errorMessage ?? "")
                    self?.errorText = error.errorMessage ?? ""
                    self?.alertType = .error
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
    var url: String?
    
    init(id: String?, userName: String?, email: String?, selectedImage: UIImage?, url: String?) {
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
            "avatar": url ?? ""
        ]
    }
}
