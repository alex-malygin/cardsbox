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
    @ObservedObject private var viewModel = CardDetailViewModel()
    
    @State private var userName: String = ""
    @State private var cardNumber: String = ""
    @Binding var viewMode: CardDetailMode
    @Binding var cardModel: CardModel

    var body: some View {
        VStack(alignment: .trailing) {
            HeaderCardDetailView(title: viewMode == .create ? Strings.createModeTitle : Strings.editModeTitle)
            ScrollView {
                VStack(spacing: 25) {
                    Spacer()
                    CardView(cardType: .constant(cardModel.cardType),
                             cardNumber: $cardNumber,
                             cardHolderName: $userName,
                             backgroundType: $cardModel.bgType)
                    Spacer()

                    VStack(spacing: 15) {
                        TextFieldView(Strings.cardDetailCardNumberPlaceholder, text: $cardNumber, maxLenth: 16)
                            .onAppear() {
                                cardNumber = viewMode == .create ? "" : cardModel.cardNumber
                            }
                            .keyboardType(.numberPad)
                        TextFieldView(Strings.cardDetailEnterNamePlaceholder, text: $userName, maxLenth: 25)
                            .onAppear() {
                                userName = viewMode == .create ? "" : cardModel.userName
                            }
                    }
                    
                    Button(action: {
                        
                    }, label: {
                        Text( viewMode == .create ? Strings.actionAddTitle : Strings.actionSaveTitle)
                            .frame(width: 250, height: 50)
                            .background(.black)
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
