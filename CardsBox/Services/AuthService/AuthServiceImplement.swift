//
//  AuthServiceImplement.swift
//  CardsBox
//
//  Created by Alexander Malygin on 5/10/22.
//

import Foundation
import FirebaseAuth

final class AuthServiceImplement: AuthService {
    private let auth = Auth.auth()
    private let dispatchGroup = DispatchGroup()
    
    func login(with model: RegisterModel, completion: ResponseClosure<Void?>?) {
        guard let email = model.email,
              let password = model.password
        else { return }
        
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] result, error in
            if let error = error {
                completion?(nil, error)
            }
            
            self?.uploadImage(model: model)
        
            self?.dispatchGroup.notify(queue: .main) {
                self?.saveProfileToStorage()
            }
            
        }
        completion?((), nil)
    }
}

private extension AuthServiceImplement {
    private func uploadImage(model: RegisterModel) {
        if model.avatar != nil {
            dispatchGroup.enter()
            
            dispatchGroup.leave()
        }
    }
    
    private func saveProfileToStorage() {
        
    }
}
