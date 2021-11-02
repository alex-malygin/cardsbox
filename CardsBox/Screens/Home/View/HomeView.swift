//
//  HomeView.swift
//  CardsBox
//
//  Created by Eugene Shapovalov on 01.06.2021.
//

import SwiftUI
import FirebaseAuth

struct HomeView: View {
    @State private var searchText = ""
    @State private var isShowingDetails = false
    @ObservedObject var viewModel: HomeViewModel
    
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
        .alert(isPresented: $viewModel.showAlert, content: {
            Alert(title: Text("Error"), message: Text($viewModel.errorText.wrappedValue), dismissButton: .cancel())
        })
        .sheet(isPresented: $viewModel.isShowingDetails) {
            let detailViewModel = CardDetailViewModel(cardModel: $viewModel.selectedCard.wrappedValue)
            CardDetailView(viewModel: detailViewModel, viewMode: $viewModel.mode)
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(viewModel: HomeViewModel())
    }
}
