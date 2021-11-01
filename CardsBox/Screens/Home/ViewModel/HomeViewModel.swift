//
//  HomeViewModel.swift
//  CardsBox
//
//  Created by Eugene Shapovalov on 14.06.2021.
//

import Foundation
import Combine
import CoreData
import FirebaseAuth

final class HomeViewModel: ObservableObject {
    // MARK: - Properties
    @Published private(set) var cardList: [CardModel] = []
    @Published var mode: CardDetailMode = .create
    @Published var selectedCard: CardModel?
    @Published var isShowingDetails: Bool = false
    
    private var cancellable = Set<AnyCancellable>()
    private let dataManager = DataManager.shared
    
    // MARK: - Init
    init() {
        if let userID = Auth.auth().currentUser?.uid {
            DatabaseManager.shared.getCards(userID: userID).sink { completion in
                
            } receiveValue: { [weak self] cardList in
                self?.cardList = cardList
            }.store(in: &cancellable)
        } else {
            
        }
    }
}
