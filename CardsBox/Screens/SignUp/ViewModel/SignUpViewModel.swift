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
    @Published var userModel = RegisterModel()
    @Published var isActive = false
    @Published var image = UIImage(named: "avatar") ?? UIImage()
    @Published var selectedImage: UIImage?
    @Published var showSheet = false
    @Published var showLoader = false
    @Published var showAlert = false
    @Published var errorText = ""
    @Published var alertType: AlertType = .error
    
    enum AlertType {
        case error
        case biometrical
    }
    
    private var cancellable = Set<AnyCancellable>()
    private let keychain = KeychainManager()
    
    init() {
        
    }
    
    func setNewImage(image: UIImage) {
        self.selectedImage = image
        self.image = image
        self.userModel.avatar = image
    }
    
    func registration() {
        showLoader = true
        AuthManager.shared.registration(user: userModel)
            .sink { [weak self] completion in
                switch completion {
                case .finished: break
                case let .failure(error):
                    debugPrint("Error register", error.errorMessage ?? "")
                    self?.showLoader = false
                    self?.showAlert = true
                    self?.alertType = .error
                    self?.errorText = error.errorMessage ?? ""
                }
            } receiveValue: { [weak self] _ in
                self?.showLoader = false
                self?.showAlert = true
                self?.alertType = .biometrical
                self?.errorText = self?.keychain.biometricType.localized ?? ""
            }.store(in: &self.cancellable)
    }
    
    func saveUserData() {
        keychain.saveCredentials(email: userModel.email, pass: userModel.password)
        DataManager.shared.isBiometriAvialable = true
        isActive = true
    }
}
