//
//  HomeViewModel.swift
//  CardsBox
//
//  Created by Eugene Shapovalov on 14.06.2021.
//

import Foundation
import Combine

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
    
    // MARK: - Init
    init() {
        getCards()
    }
    
    func getCards() {
        showLoader = true
        FirestoreManager.shared.getCards()
            .sink { [weak self] completion in
                switch completion {
                case .finished: break
                case let .failure(error):
                    self?.showLoader = false
                    self?.showAlert = true
                    self?.errorText = error.errorMessage ?? ""
                }
            } receiveValue: { [weak self] cards in
                self?.showLoader = false
                self?.cardList = cards ?? []
            }.store(in: &cancellable)
    }
    
    func deleteCard(cardID: String) {
        FirestoreManager.shared.deleteCard(id: cardID)
    }
}
