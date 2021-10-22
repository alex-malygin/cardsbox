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
    @ObservedObject private var viewModel = HomeViewModel()
    
    var body: some View {
        NavigationView {
            ScrollView(showsIndicators: false) {
                LazyVStack {
                    ForEach(viewModel.cardList, id: \.id) { card in
                        Button(action: {
                            viewModel.selectedCard = card
                            viewModel.mode = .edit
                            isShowingDetails = true
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
            .navigationBarTitle(Strings.mainTitle)
            .navigationBarItems(trailing:
                                    Button(action: {
                                    viewModel.mode = .create
                                    isShowingDetails = true
                                }, label: {
                                    Image(systemName: "plus")
                                        .font(.system(size: 22.0, weight: .medium))
                                }))
            .sheet(isPresented: $isShowingDetails) {
                CardDetailView(viewMode: $viewModel.mode, cardModel: $viewModel.selectedCard)
            }
        }
        .navigationViewStyle(.stack)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
