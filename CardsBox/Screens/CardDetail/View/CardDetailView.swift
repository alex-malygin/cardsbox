//
//  CardDetailView.swift
//  CardsBox
//
//  Created by Eugene Shapovalov on 15.06.2021.
//

import SwiftUI
import Combine

enum CardDetailMode {
    case create, edit
}

struct CardDetailView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var userName: String = ""
    @State private var cardNumber: String = ""
    @Binding var viewMode: CardDetailMode
    @Binding var cardModel: Card
    @ObservedObject private var viewModel = CardDetailViewModel()

    var body: some View {
        VStack(alignment: .trailing) {
            HeaderCardDetailView(title: viewMode == .create ? "Create" : "Edit")
            ScrollView {
                VStack(spacing: 25) {
                    Spacer()
                    CardView(cardType: "VISA",
                             cardNumber: cardNumber,
                             cardHolderName: userName,
                             backgroundCard: defaultCardBackground)
                    Spacer()

                    VStack(spacing: 15) {
                        TextFieldView("Card Number", text: $cardNumber, maxLenth: 16)
                            .onAppear() {
                                cardNumber = (viewMode == .create ? "" : cardModel.cardNumber) ?? ""
                            }
                            .onChange(of: cardNumber, perform: { value in
                                cardNumber = value
                            })
                            .keyboardType(.numberPad)
                        
                        TextFieldView("Enter name", text: $userName, maxLenth: 25)
                            .onAppear() {
                                userName = (viewMode == .create ? "" : cardModel.userName) ?? ""
                            }
                            .onChange(of: userName, perform: { value in
                                userName = value
                            })
                    }
                    
                    Button(action: {
                        let card = CardModel(userName: userName, cardNumber: cardNumber)
                        viewMode == .create ? viewModel.addNewCard(card) : viewModel.updateCard(card)
                        presentationMode.wrappedValue.dismiss()
                    },
                    label: {
                        Text( viewMode == .create ? "Add" : "Save")
                            .frame(width: 250, height: 50)
                            .background(gradient1)
                            .foregroundColor(.white)
                            .cornerRadius(8.0)
                    })
                }
                .padding()
            }
            .onTapGesture {
                hideKeyboard()
            }
        }
        .background(grayBackgroundView)
        .ignoresSafeArea(.all, edges: .bottom)
    }
}

struct HeaderCardDetailView: View {
    @Environment(\.presentationMode) var presentationMode
    var title: String
    
    var body: some View {
        HStack {
            Text(title)
                .font(.system(size: 27.0, weight: .semibold))
            Spacer()
            Button(action: {
                presentationMode.wrappedValue.dismiss()
            }, label: {
                Image(systemName: "xmark")
                    .font(.system(size: 24.0, weight: .regular))
            })
        }
        .padding()
    }
}
