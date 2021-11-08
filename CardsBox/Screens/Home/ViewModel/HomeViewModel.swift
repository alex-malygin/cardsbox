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
    @Published var showLoader = false
    @Published var showAlert = false
    @Published var errorText = ""
    
    private var cancellable = Set<AnyCancellable>()
    private let dataManager = DataManager.shared
    
    // MARK: - Init
    init() {
        if let userID = Auth.auth().currentUser?.uid {
            showLoader = true
            DatabaseManager.shared.getCards(userID: userID).sink { completion in
                switch completion {
                case .finished: break
                case let .failure(error):
                    debugPrint("Error login", error)
                    self.errorText = error.localizedDescription
                    self.showAlert = true
                    self.showLoader = false
                }
            } receiveValue: { [weak self] cardList in
                self?.showLoader = false
                self?.cardList = cardList
            }.store(in: &cancellable)
        } else {
            errorText = "UserID not found!"
        }
    }
    
    func deleteCard(cardID: String) {
        DatabaseManager.shared.deleteCard(cardID: cardID).sink { completion in
            
        } receiveValue: { success in
            
        }.store(in: &cancellable)
    }
}
