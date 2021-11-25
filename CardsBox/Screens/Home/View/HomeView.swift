//
//  HomeView.swift
//  CardsBox
//
//  Created by Eugene Shapovalov on 01.06.2021.
//

import SwiftUI

struct HomeView: View {
    @ObservedObject var viewModel: HomeViewModel
    @EnvironmentObject var viewModels: ViewModelsFactory
        
    var body: some View {
        ZStack {
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
                                .contextMenu {
                                    Button {
                                        viewModel.deleteCard(cardID: card.id)
                                    } label: {
                                        Text("Delete")
                                    }
                                }
                        }
                        .buttonStyle(PlainButtonStyle())
                        .padding([.top, .bottom], 0)
                        .padding([.trailing, .leading], 8)
                    }
                    .padding(.top, 10)
                }
            }
            
            ActivityIndicator(shouldAnimate: $viewModel.showLoader)
        }
        .navigationTitle(Strings.mainTitle)
        .background(Color.mainGrayColor)
        .alert(isPresented: $viewModel.showAlert, content: {
            Alert(title: Text("Error"), message: Text($viewModel.errorText.wrappedValue), dismissButton: .cancel())
        })
        .sheet(isPresented: $viewModel.isShowingDetails) {
            CardDetailView(viewModel: viewModels.makeCardDetailViewModel(),
                           selectedCard: viewModel.selectedCard,
                           viewMode: viewModel.mode)
        }
        .ignoresSafeArea(.container, edges: .bottom)
    }
}

