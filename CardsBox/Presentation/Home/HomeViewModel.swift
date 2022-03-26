//
//  HomeViewModel.swift
//  CardsBox
//
//  Created by Eugene Shapovalov on 14.06.2021.
//

import Foundation
import Combine
import UIKit

final class HomeViewModel: ObservableObject {
    // MARK: - Properties
    @Published private(set) var cardList: [CardModel] = []
    @Published var mode: CardDetailMode = .create
    @Published var selectedCard: CardModel?
    @Published var profile: UserProfileModel?
    @Published var image = UIImage(named: "avatar") ?? UIImage()
    @Published var isShowingDetails: Bool = false
    @Published var showLoader = false
    @Published var showAlert = false
    @Published var errorText = ""
    @Published var shareItems = [String]()
    
    private var cancellable = Set<AnyCancellable>()
    
    private let firestoreService: FirestoreServiceProtocol
    
    // MARK: - Init
    init(firestoreService: FirestoreServiceProtocol = FirestoreManager()) {
        self.firestoreService = firestoreService
        DataManager.shared.subject.sink { [weak self] profile in
            self?.profile = profile
        }.store(in: &cancellable)
    }
    
    func getProfile() {
        firestoreService.getProfile()
    }
    
    func getCards() {
        showLoader = true
        firestoreService.getCards()
            .receive(on: DispatchQueue.main)
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
                self?.cardList = cards?.sorted(by: { $0.date > $1.date }) ?? []
            }.store(in: &cancellable)
    }
    
    func deleteCard(cardID: String) {
        firestoreService.deleteCard(id: cardID)
    }
}
