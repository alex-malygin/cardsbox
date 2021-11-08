//
//  CardModel.swift
//  CardsBox
//
//  Created by Eugene Shapovalov on 8/26/21.
//

import Foundation

struct CardModel: Hashable {
    var id: String
    var cardType: String
    var userName: String
    var cardNumber: String
    var cardBG: String
    
    var bgType: BackgroundCardType {
        get {
            return BackgroundCardType(rawValue: cardBG) ?? .default
        }
        set {
            cardBG = newValue.rawValue
        }
    }
    
    init() {
        self.id = UUID().uuidString
        self.cardType = ""
        self.userName = ""
        self.cardNumber = ""
        self.cardBG = "default"
    }
    
    init(id: String, cardType: String, userName: String, cardNumber: String, bgType: BackgroundCardType) {
        self.id = id
        self.cardType = cardType
        self.userName = userName
        self.cardNumber = cardNumber
        self.cardBG = bgType.rawValue
    }
    
    static func == (lhs: CardModel, rhs: CardModel) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
