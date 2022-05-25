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
    func showRegisterScreen()
    func changePasswordImage()
    func handleEmailField(text: String?)
    func handlePasswordlField(text: String?)
}

protocol LoginViewModelOutputs: AnyObject {
    var showLoader: Observer<Bool> { get set }
    var setPasswordImageName: ItemClosure<String>? { get set }
    var showRegisterScreenAction: VoidClosure? { get set }
    var showAlert: ItemClosure<[LoginViewModel.Alert]>? { get set }
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
    
    //MARK: - Init
    init() { }
    
    //MARK: - LoginViewModelOutputs
    var showLoader: Observer<Bool> = .init(false)
    var setPasswordImageName: ItemClosure<String>?
    var showRegisterScreenAction: VoidClosure?
    var showAlert: ItemClosure<[LoginViewModel.Alert]>?
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
        //add requst
    }
    
    func showRegisterScreen() {
        showRegisterScreenAction?()
    }
    
    func changePasswordImage() {
        showPassword.toggle()
        setPasswordImageName?(showPassword ? "eye" : "eye.slash")
    }
}
