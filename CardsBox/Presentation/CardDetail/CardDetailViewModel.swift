//
//  CardDetailViewModel.swift
//  CardsBox
//
//  Created by Eugene Shapovalov on 8/26/21.
//

import Foundation
import Combine

final class CardDetailViewModel: ObservableObject {
    @Published var cardModel: CardModel
    @Published var cardBG: [BackgroundCardType] = [.default, .ohhappiness, .flare, .black, .white]
    @Published var isPresented = false
    @Published var showLoader = false
    @Published var showAlert = false
    @Published var errorText = ""
    
    var cancellable = Set<AnyCancellable>()
    
    private let firestoreService: FirestoreServiceProtocol
    
    init(firestoreService: FirestoreServiceProtocol, cardModel: CardModel?) {
        self.firestoreService = firestoreService
        self.cardModel = cardModel ?? CardModel()
    }
    
    func addCard() {
        firestoreService.addCard(model: cardModel)
            .sink { [weak self] completion in
                switch completion {
                case .finished: break
                case let .failure(error):
                    self?.showLoader = false
                    self?.showAlert = false
                    self?.errorText = error.errorMessage ?? ""
                }
            } receiveValue: { [weak self] _ in
                self?.isPresented = false
            }.store(in: &cancellable)
    }
    
    func updateCard() {
        cardModel.date = Date().currentTimeMillis()        
        firestoreService.updateCard(model: cardModel)
            .sink { [weak self] completion in
                switch completion {
                case .finished: break
                case let .failure(error):
                    self?.showLoader = false
                    self?.errorText = error.errorMessage ?? ""
                }
            } receiveValue: { [weak self] _ in
                self?.isPresented = false
            }.store(in: &cancellable)
    }
}
