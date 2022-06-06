//
//  LoginViewModel.swift
//  CardsBox
//
//  Created by Alexander Malygin on 4/4/22.
//

import Foundation
import UIKit

protocol LoginViewModelType {
    var input: LoginViewModelInputs { get }
    var output: LoginViewModelOutputs { get }
}

protocol LoginViewModelInputs {
    func viewDidLoad()
    func login()
    func authWithBiometricalData()
    func showRegisterScreen()
    func changePasswordImage()
    func handleEmailField(text: String?)
    func handlePasswordlField(text: String?)
}

protocol LoginViewModelOutputs: AnyObject {
    var isBiomericAvailable: Bool { get }
    var emailIcon: UIImage? { get }
    var showLoader: Observer<Bool> { get set }
    var setPasswordImage: ItemClosure<UIImage?>? { get set }
    var showRegisterScreenAction: VoidClosure? { get set }
    var showAlert: ItemClosure<[LoginViewModel.Alert]>? { get set }
    var reloadTextFields: VoidClosure? { get set }
    var showMain: VoidClosure? { get set }
}

//MARK: - LoginViewModel Alert
extension LoginViewModel {
    enum Alert {
        case other(message: String)
        
        var message: String {
            switch self {
            case .other(let message): return message
            }
        }
    }
}

final class LoginViewModel: LoginViewModelType, LoginViewModelOutputs {
    //MARK: - Setup ViewModelType Properties
    var input: LoginViewModelInputs { return self }
    var output: LoginViewModelOutputs { return self }
    
    //MARK: - Private properties
    private var showPassword = false
    private var email: String?
    private var password: String?
    
    private let keychain = KeychainManager()
    
    //MARK: - Init
    init() { }
    
    //MARK: - LoginViewModelOutputs
    var isBiomericAvailable: Bool { return DataManager.shared.isBiometriAvialable }
    var emailIcon: UIImage? {
        switch keychain.biometricType {
        case .none: return nil
        case .touch: return UIImage(systemName: "touchid")
        case .face: return UIImage(systemName: "faceid")
        }
    }
    
    var showLoader: Observer<Bool> = .init(false)
    var setPasswordImage: ItemClosure<UIImage?>?
    var showRegisterScreenAction: VoidClosure?
    var showAlert: ItemClosure<[LoginViewModel.Alert]>?
    var reloadTextFields: VoidClosure?
    var showMain: VoidClosure?
}

//MARK: - LoginViewModelInputs
extension LoginViewModel: LoginViewModelInputs {
    func viewDidLoad() {
        
    }
    
    func handleEmailField(text: String?) {
        email = text
    }
    
    func handlePasswordlField(text: String?) {
        password = text
    }
    
    func authWithBiometricalData() {
        let creds = keychain.getCredentials(message: "Access your password on the keychain")

        email = creds.email
        password = creds.pass
        
        reloadTextFields?()
        
        login()
    }
    
    func login() {
        guard let email = email, let password = password else {
            showAlert?([.other(message: Strings.loginFieldError)])
            return
        }
        
        showLoader.value = true
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
        if email.isEmpty, password.isEmpty {
            showLoader.value = false
            showAlert?([.other(message: Strings.loginFieldError)])
            return
        }
        
        showLoader.value = false
        saveUserData()
        //add requst
        showMain?()
    }
    
    func showRegisterScreen() {
        showRegisterScreenAction?()
    }
    
    func changePasswordImage() {
        showPassword.toggle()
        setPasswordImage?(showPassword ? UIImage(systemName: "eye") : UIImage(systemName: "eye.slash"))
    }
    
    private func saveUserData() {
        keychain.saveCredentials(email: email, pass: password)
        DataManager.shared.isBiometriAvialable = true
    }
}
