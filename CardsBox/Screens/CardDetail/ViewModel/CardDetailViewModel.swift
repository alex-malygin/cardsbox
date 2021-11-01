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
    
    private var cancellable = Set<AnyCancellable>()
    
    init(cardModel: CardModel?) {
        if let cardModel = cardModel {
            self.cardModel = cardModel
        } else {
            self.cardModel = CardModel()
        }
    }
    
    func addCard() {
        DatabaseManager.shared.addCard(card: cardModel)
            .sink { completion in
                
            } receiveValue: { [weak self] success in
                self?.isPresented = false
            }.store(in: &cancellable)
    }
    
    func updateCard() {
        DatabaseManager.shared.updateCard(card: cardModel)
            .sink { completion in
                
            } receiveValue: { [weak self] success in
                self?.isPresented = true
            }.store(in: &cancellable)
    }
}
