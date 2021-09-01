//
//  HomeView.swift
//  CardsBox
//
//  Created by Eugene Shapovalov on 01.06.2021.
//

import SwiftUI
import Introspect

struct HomeView: View {
    @State private var searchText = ""
    @State private var isShowingDetails = false
    @State private var mode: CardDetailMode = .create
    @State private var selectedCardModel: Card = Card()
    @ObservedObject private var viewModel = HomeViewModel()
    
    var body: some View {
        List {
            ForEach(viewModel.cardList) { card in
                Button(action: {
                    mode = .edit
                    isShowingDetails = true
                    selectedCardModel = card
                }) {
                    CardView(cardType: "VISA",
                             cardNumber: card.cardNumber ?? "",
                             cardHolderName: card.userName ?? "",
                             backgroundCard: defaultCardBackground)
                        .listRowInsets(.init(top: 5, leading: 0, bottom: 5, trailing: 0))
                        .listRowBackground(grayBackgroundView)
                }
                .buttonStyle(PlainButtonStyle())
            }
            .onDelete(perform: viewModel.delete)
        }
        .introspectTableView { tableView in
            tableView.separatorStyle = .none
        }
        .listStyle(PlainListStyle())
        .navigationBarTitle(Strings.mainTitle)
        .navigationBarItems(trailing: Button(action: {
                                mode = .create
                                isShowingDetails = true
                            }, label: {
                                Image(systemName: "plus")
                                    .font(.system(size: 24.0, weight: .medium))
                            }))
        .sheet(isPresented: $isShowingDetails) {
            CardDetailView(viewMode: $mode, cardModel: $selectedCardModel)
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
