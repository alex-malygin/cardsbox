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
    enum AlertType {
        case error, biometrical
    }
    //Properties
    @Published var userModel = RegisterModel()
    @Published var image = UIImage(named: "avatar") ?? UIImage()
    @Published var selectedImage: UIImage?
    @Published var showSheet = false
    @Published var showLoader = false
    @Published var showAlert = false
    @Published var errorText = ""
    @Published var alertType: AlertType = .error
    
    private var cancellable = Set<AnyCancellable>()
    private let keychain = KeychainManager()
    
    //Protocols
    private var dataManager: DataManagerProtocol
    private let authManager: AuthManagerProtocol
    
    init(dataManager: DataManagerProtocol, authManager: AuthManagerProtocol) {
        self.dataManager = dataManager
        self.authManager = authManager
    }
    
    func setNewImage(image: UIImage) {
        self.selectedImage = image
        self.image = image
        self.userModel.avatar = image
    }
    
    func registration() {
        showLoader = true
        authManager.registration(user: userModel)
            .sink { [weak self] completion in
                switch completion {
                case .finished: break
                case let .failure(error):
                    debugPrint("Error register", error.errorMessage ?? "")
                    self?.showLoader = false
                    self?.errorText = error.errorMessage ?? ""
                    self?.showAlert = true
                    self?.alertType = .error
                }
            } receiveValue: { [weak self] _ in
                self?.showLoader = false
                self?.errorText = self?.keychain.biometricType.localized ?? ""
                self?.showAlert = true
                self?.alertType = .biometrical
            }.store(in: &self.cancellable)
    }
    
    func saveUserData() {
        keychain.saveCredentials(email: userModel.email, pass: userModel.password)
        dataManager.isBiometriAvialable = true
        
    }
}
