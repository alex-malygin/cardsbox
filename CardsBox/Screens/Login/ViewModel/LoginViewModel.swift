//
//  LoginViewModel.swift
//  CardsBox
//
//  Created by Alexander Malygin on 10/29/21.
//

import Combine

class LoginViewModel: ObservableObject {
    @Published var userModel = UserProfileModel()
    @Published var isActive = false
    @Published var showLoader = false
    @Published var showAlert = false
    @Published var errorText = ""
    
    private var cancellable = Set<AnyCancellable>()
    
    func login() {
        showLoader = true
        FirebaseManager.shared.login(user: userModel).sink { completion in
            switch completion {
            case .finished: break
            case let .failure(error):
                debugPrint("Error login", error)
                self.errorText = error.localizedDescription
                self.showAlert = true
                self.showLoader = false
            }
        } receiveValue: { success in
            self.isActive = true
            self.showLoader = false
        }
        .store(in: &self.cancellable)
    }
}
