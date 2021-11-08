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
    @Published var profile = UserProfileModel()
    @Published var image = UIImage(named: "avatar") ?? UIImage()
    @Published var selectedImage: UIImage?
    @Published var showLoader = false
    @Published var showAlert = false
    @Published var errorText = ""
    
    private var cancellable = Set<AnyCancellable>()
    
    init() {
        if let profile = DataManager.shared.userProfile {
            self.profile = profile
        }
    }
    
    func setNewImage(image: UIImage) {
        self.selectedImage = image
        self.image = image
    }
    
    func save() {
        showLoader = true
        if selectedImage == nil {
            DatabaseManager.shared.updateUserProfile(user: profile)
                .sink { completion in
                    switch completion {
                    case .finished: break
                    case let .failure(error):
                        debugPrint("Error updateUserProfile", error)
                        self.errorText = error.localizedDescription
                        self.showAlert = true
                        self.showLoader = false
                    }
                } receiveValue: { [weak self] success in
                    self?.showLoader = false
                }
                .store(in: &self.cancellable)
        } else {
            FirebaseManager.shared.updateAvatar(user: profile, avatar: selectedImage)
                .sink { completion in
                    switch completion {
                    case .finished: break
                    case let .failure(error):
                        debugPrint("Error updateAvatar", error)
                        self.errorText = error.localizedDescription
                        self.showAlert = true
                        self.showLoader = false
                    }
                } receiveValue: { [weak self] success in
                    self?.showLoader = false
                }
                .store(in: &self.cancellable)
        }
    }
}
