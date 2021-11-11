//
//  LoginViewModel.swift
//  CardsBox
//
//  Created by Alexander Malygin on 10/29/21.
//

import Combine
import Foundation
import UIKit

class LoginViewModel: ObservableObject {
    @Published var userModel = RegisterModel()
    @Published var isActive = false
    @Published var showLoader = false
    @Published var showAlert = false
    @Published var errorText = ""
    
    private var cancellable = Set<AnyCancellable>()
    private let keychain = KeychainManager()
    var isBiomericAvailable: Bool { return DataManager.shared.isBiometriAvialable }
    var emailIcon: UIImage? {
        switch keychain.biometricType {
        case .none: return nil
        case .touch: return UIImage(systemName: "touchid")
        case .face: return UIImage(systemName: "faceid")
        }
    }
    
    init() {
    }
    
    func login() {
        showLoader = true
        AuthManager.shared.login(user: userModel).sink { [weak self] completion in
            switch completion {
            case .finished: break
            case let .failure(error):
                debugPrint("Error login", error)
                self?.errorText = error.localizedDescription
                self?.showAlert = true
                self?.showLoader = false
            }
        } receiveValue: { [weak self] _ in
            self?.isActive = true
            self?.showLoader = false
            self?.saveUserData()
        }
        .store(in: &self.cancellable)
    }
    
    func startBiomeric() {
        let creds = keychain.getCredentials(message: "Access your password on the keychain")

        userModel.email = creds.email
        userModel.password = creds.pass
        
        login()
    }
    
    private func saveUserData() {
        keychain.saveCredentials(email: userModel.email, pass: userModel.password)
        DataManager.shared.isBiometriAvialable = true
    }
    
}
