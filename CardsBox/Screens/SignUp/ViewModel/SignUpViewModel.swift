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
    @Published var userModel = UserProfileModel()
    @Published var isActive = false
    @Published var image = UIImage(named: "avatar") ?? UIImage()
    @Published var selectedImage: UIImage?
    @Published var showSheet = false
    @Published var showLoader = false
    @Published var showAlert = false
    @Published var errorText = ""
    
    private var cancellable = Set<AnyCancellable>()
    
    init() {
        
    }
    
    func setNewImage(image: UIImage) {
        self.selectedImage = image
        self.image = image
    }
    
    func registration() {
        showLoader = true
        FirebaseManager.shared.registration(user: userModel, avatar: selectedImage)
            .sink { completion in
                switch completion {
                case .finished: break
                case let .failure(error):
                    debugPrint("Error register", error)
                    self.errorText = error.localizedDescription
                    self.showAlert = true
                    self.showLoader = false
                }
            } receiveValue: { [weak self] success in
                self?.isActive = true
                self?.showLoader = false
            }
            .store(in: &self.cancellable)
    }
}
