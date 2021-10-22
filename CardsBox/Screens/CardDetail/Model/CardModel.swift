//
//  CardModel.swift
//  CardsBox
//
//  Created by Eugene Shapovalov on 8/26/21.
//

import Foundation

struct CardModel: Identifiable {
    var id: UUID
    var cardType: String
    var userName: String
    var cardNumber: String
    var bgType: BackgroundCardType
}
