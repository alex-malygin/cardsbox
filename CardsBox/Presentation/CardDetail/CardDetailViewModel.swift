//
//  CardDetailViewModel.swift
//  CardsBox
//
//  Created by Eugene Shapovalov on 8/26/21.
//

import Foundation
import Combine

final class CardDetailViewModel: ObservableObject {
    enum AlertType {
        case error
        case scaner
    }
    
    @Published var cardModel: CardModel
    @Published var cardBG: [BackgroundCardType] = [.default, .ohhappiness, .flare, .black, .white]
    @Published var isPresented = true
    @Published var showLoader = false
    @Published var showAlert = false
    @Published var alertType: AlertType = .error
    @Published var errorText = ""
    
    var cancellable = Set<AnyCancellable>()
    
    private let firestoreService: FirestoreServiceProtocol
    
    init(firestoreService: FirestoreServiceProtocol = FirestoreManager(), cardModel: CardModel?) {
        self.firestoreService = firestoreService
        self.cardModel = cardModel ?? CardModel()
    }
    
    func addCard() {
        if cardModel.userName.isEmpty && cardModel.cardNumber.isEmpty {
            errorText = "Please fill all fields"
            showAlert = true
            return
        }
        
        firestoreService.addCard(model: cardModel)
            .sink { [weak self] completion in
                switch completion {
                case .finished: break
                case let .failure(error):
                    self?.showLoader = false
                    self?.showAlert = true
                    self?.alertType = .error
                    self?.errorText = error.errorMessage ?? ""
                }
            } receiveValue: { [weak self] _ in
                self?.isPresented = false
            }.store(in: &cancellable)
    }
    
    func updateCard() {
        if cardModel.userName.isEmpty && cardModel.cardNumber.isEmpty {
            errorText = "Please fill all fields"
            alertType = .error
            showAlert = true
            return
        }
        
        cardModel.date = Date().currentTimeMillis()        
        firestoreService.updateCard(model: cardModel)
            .sink { [weak self] completion in
                switch completion {
                case .finished: break
                case let .failure(error):
                    self?.showLoader = false
                    self?.alertType = .error
                    self?.errorText = error.errorMessage ?? ""
                }
            } receiveValue: { [weak self] _ in
                self?.isPresented = false
            }.store(in: &cancellable)
    }
}
