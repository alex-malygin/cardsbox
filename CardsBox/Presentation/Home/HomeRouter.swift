//
//  HomeRouter.swift
//  CardsBox
//
//  Created by Alexander Malygin on 12/11/21.
//

import Foundation
import SwiftUI

final class HomeRouter {
    public static func showCardDetail(cardModel: CardModel?, viewMode: Binding<CardDetailMode>) -> some View {
        return CardDetailConfigurator.configureCardDetail(cardModel: cardModel, viewMode: viewMode)
    }
}
