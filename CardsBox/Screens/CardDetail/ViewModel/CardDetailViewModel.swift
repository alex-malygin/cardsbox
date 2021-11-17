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
    
    init(cardModel: CardModel?) {
        if let cardModel = cardModel {
            self.cardModel = cardModel
        } else {
            self.cardModel = CardModel()
        }
    }
    
    func addCard() {
        FirestoreManager.shared.addCard(model: cardModel)
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
        FirestoreManager.shared.updateCard(model: cardModel)
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
