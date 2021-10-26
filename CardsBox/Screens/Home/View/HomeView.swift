//
//  HomeView.swift
//  CardsBox
//
//  Created by Eugene Shapovalov on 01.06.2021.
//

import SwiftUI

struct HomeView: View {
    @State private var searchText = ""
    @State private var isShowingDetails = false
    @ObservedObject var viewModel: HomeViewModel
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            LazyVStack {
                ForEach(viewModel.cardList, id: \.id) { card in
                    Button(action: {
                        viewModel.selectedCard = card
                        viewModel.mode = .edit
                        viewModel.isShowingDetails = true
                    }) {
                        CardView(cardType: .constant(card.cardType),
                                 cardNumber: .constant(card.cardNumber),
                                 cardHolderName: .constant(card.userName),
                                 backgroundType: .constant(card.bgType))
                    }
                    .buttonStyle(PlainButtonStyle())
                    .padding([.top, .bottom], 0)
                    .padding([.trailing, .leading], 8)
                }
            }
        }
        .sheet(isPresented: $viewModel.isShowingDetails) {
            CardDetailView(viewMode: $viewModel.mode, cardModel: $viewModel.selectedCard)
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(viewModel: HomeViewModel())
    }
}
