//
//  HomeViewModel.swift
//  CardsBox
//
//  Created by Eugene Shapovalov on 14.06.2021.
//

import Foundation
import Combine
import CoreData

final class HomeViewModel: ObservableObject {
    // MARK: - Properties
    @Published private(set) var cardList: [CardModel] = []
    @Published var mode: CardDetailMode = .create
    @Published var selectedCard: CardModel
    
    // MARK: - Init
    init() {
        cardList = [
            CardModel(id: UUID(), cardType: "VISA", userName: "Test User", cardNumber: "1234122333365554", bgType: .default),
            CardModel(id: UUID(), cardType: "Master Card", userName: "Test User", cardNumber: "1234122333365554", bgType: .flare),
            CardModel(id: UUID(), cardType: "VISA", userName: "Test User", cardNumber: "1234122333365554", bgType: .ohhappiness),
            CardModel(id: UUID(), cardType: "VISA", userName: "Test User", cardNumber: "1234122333365254", bgType: .flare),
            CardModel(id: UUID(), cardType: "Master Card", userName: "Test User", cardNumber: "1234122333365554", bgType: .ohhappiness),
            CardModel(id: UUID(), cardType: "Master Card", userName: "Test User", cardNumber: "1234122333365554", bgType: .default),
            CardModel(id: UUID(), cardType: "VISA", userName: "Test User", cardNumber: "1234122333365554", bgType: .ohhappiness),
            CardModel(id: UUID(), cardType: "Master Card", userName: "Test User", cardNumber: "1234122333361312", bgType: .flare),
            CardModel(id: UUID(), cardType: "VISA", userName: "Test User", cardNumber: "1234122333365554", bgType: .default),
            CardModel(id: UUID(), cardType: "Master Card", userName: "Test User", cardNumber: "1234122333365545", bgType: .default),
        ]
        selectedCard = CardModel(id: UUID(), cardType: "Master Card", userName: "", cardNumber: "", bgType: .default)
    }
}
