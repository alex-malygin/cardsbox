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
    //Properties
    @Published var profileInfo = ProfileInfo(nil)
    @Published var image = UIImage(named: "avatar") ?? UIImage()
    @Published var showLoader = false
    @Published var showAlert = false
    @Published var errorText = ""
    
    private var cancellable = Set<AnyCancellable>()
    
    //Protocols
    private var dataManager: DataManagerProtocol
    private var firestoreManager: FirestoreManagerProtocol
    
    init(dataManager: DataManagerProtocol, firestoreManager: FirestoreManagerProtocol) {
        self.dataManager = dataManager
        self.firestoreManager = firestoreManager
        self.profileInfo = ProfileInfo(dataManager.userProfile)
    }
    
    func setNewImage(image: UIImage) {
        self.image = image
        self.profileInfo.selectedImage = image
    }
    
    func save() {
        showLoader = true
        firestoreManager.updateProfile(profileInfo: profileInfo)
            .sink { [weak self] completion in
                switch completion {
                case .finished: break
                case let .failure(error):
                    debugPrint("Error register", error.errorMessage ?? "")
                    self?.errorText = error.errorMessage ?? ""
                    self?.showAlert = true
                    self?.showLoader = false
                }
        } receiveValue: { [weak self] _ in
            self?.showLoader = false
        }.store(in: &cancellable)
    }
}
