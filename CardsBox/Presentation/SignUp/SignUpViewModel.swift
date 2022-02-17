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
        case fieldEmpty
    }
    
    private var cancellable = Set<AnyCancellable>()
    private let keychain = KeychainManager()
    
    private let authService: AuthServiceProtocol
    
    init(authService: AuthServiceProtocol) {
        self.authService = authService
    }
    
    func setNewImage(image: UIImage) {
        self.selectedImage = image
        self.image = image
        self.userModel.avatar = image
    }
    
    func registration() {
        handleError()
    }
    
    func saveUserData() {
        keychain.saveCredentials(email: userModel.email, pass: userModel.password)
        DataManager.shared.isBiometriAvialable = true
        isActive = true
    }
    
    private func handleError() {
        guard let userName = userModel.userName, let email = userModel.email, let password = userModel.password else {
            showAlert = true
            alertType = .fieldEmpty
            errorText = Strings.registerFieldError
            return
        }
        
        if userName.isEmpty && email.isEmpty && password.isEmpty {
            showAlert = true
            alertType = .fieldEmpty
            errorText = Strings.registerFieldError

            return
        }
        
        showLoader = true
        authService.registration(user: userModel)
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
}
