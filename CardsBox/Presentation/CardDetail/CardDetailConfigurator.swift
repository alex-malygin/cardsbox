//
//  CardDetailConfigurator.swift
//  CardsBox
//
//  Created by Alexander Malygin on 12/11/21.
//

import Foundation
import SwiftUI

final class CardDetailConfigurator {
    public static func configureCardDetail(cardModel: CardModel?, viewMode: Binding<CardDetailMode>) -> CardDetailView {
        let viewModel = CardDetailViewModel(cardModel: cardModel)
        let view = CardDetailView(viewModel: viewModel, viewMode: viewMode)
        return view
    }
}
