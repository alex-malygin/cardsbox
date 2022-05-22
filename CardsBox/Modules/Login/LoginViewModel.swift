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
}

protocol LoginViewModelOutputs: AnyObject {
    
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

final class LoginViewModel: LoginViewModelType {
    //MARK: - Setup ViewModelType Properties
    var input: LoginViewModelInputs { return self }
    var output: LoginViewModelOutputs { return self }
    
    //MARK: - Init
    init() {
        
    }
}

//MARK: - LoginViewModelInputs
extension LoginViewModel: LoginViewModelInputs {
    func viewDidLoad() {
        
    }
    
    func login() {
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
    }
}

//MARK: - LoginViewModelOutputs
extension LoginViewModel: LoginViewModelOutputs {
    
}
