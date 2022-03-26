//
//  CardModel.swift
//  CardsBox
//
//  Created by Eugene Shapovalov on 8/26/21.
//

import Foundation

struct CardModel: Hashable, Codable {
    var id: String
    var date: Int
    var cardType: String
    var userName: String
    var cardNumber: String
    var cardBG: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case cardType = "card_type"
        case userName = "user_name"
        case cardNumber = "card_number"
        case cardBG
        case date
        
    }
    
    
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
        self.date = Date().currentTimeMillis()
    }
    
    init(id: String, cardType: String, userName: String, cardNumber: String, bgType: BackgroundCardType, date: Int) {
        self.id = id
        self.cardType = cardType
        self.userName = userName
        self.cardNumber = cardNumber
        self.cardBG = bgType.rawValue
        self.date = date
        
    }
    
    var cardDictionary: [ String : [String: Any]] {
        return [
            "\(id)": ["id": id,
             "card_type": cardType,
             "user_name": userName,
             "card_number": cardNumber,
             "cardBG": cardBG,
             "date": date]]
    }
    
    static func == (lhs: CardModel, rhs: CardModel) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
