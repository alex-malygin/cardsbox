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
    @ObservedObject var viewModel: CardDetailViewModel
    
    @State private var userName: String = ""
    @State private var cardNumber: String = ""
    @State private var selectedBG: BackgroundCardType = .default
    @Binding var viewMode: CardDetailMode

    var body: some View {
        ZStack {
            Color.grayBackgroundView
                .ignoresSafeArea()
            
            VStack(alignment: .leading) {
                HeaderCardDetailView(title: viewMode == .create ? Strings.createModeTitle : Strings.editModeTitle)
                ScrollView() {
                    VStack(spacing: 25) {
                        Spacer()
                        CardView(cardType: .constant(viewModel.cardModel.cardType),
                                 cardNumber: $cardNumber,
                                 cardHolderName: $userName,
                                 backgroundType: $viewModel.cardModel.bgType)
                        Spacer()

                        VStack(spacing: 15) {
                            TextFieldView(Strings.cardDetailCardNumberPlaceholder, text: $cardNumber, maxLenth: 16)
                                .onAppear() {
                                    cardNumber = viewMode == .create ? "" : viewModel.cardModel.cardNumber
                                }
                                .onChange(of: cardNumber, perform: { newValue in
                                    viewModel.cardModel.cardNumber = newValue
                                })
                                .keyboardType(.numberPad)
                            
                            TextFieldView(Strings.cardDetailEnterNamePlaceholder, text: $userName, maxLenth: 25)
                                .onAppear() {
                                    userName = viewMode == .create ? "" : viewModel.cardModel.userName
                                }
                                .onChange(of: userName, perform: { newValue in
                                    viewModel.cardModel.userName = newValue
                                })
                                .ignoresSafeArea(.keyboard)
                        }
       
                        VStack() {
                            HStack {
                                Text("Select background card:")
                                    .fontWeight(.semibold)
                                Spacer()
                            }
                            .padding()
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack {
                                    ForEach(viewModel.cardBG, id: \.self) { type in
                                        Spacer()
                                        BackgroundCardView(viewModel: BackgroundCardViewModel(backgroundType: type,
                                                                                              isSelected: type == selectedBG))
                                            .onTapGesture {
                                                viewModel.cardModel.bgType = type
                                                selectedBG = type
                                            }
                                        Spacer()
                                    }
                                }
                            }
                        }
                        
                        Button(action: {
                            viewMode == .create ? viewModel.addCard() : viewModel.updateCard()
                        }, label: {
                            Text( viewMode == .create ? Strings.mainAddNewButton : Strings.actionSaveTitle)
                                .fontWeight(.semibold)
                                .frame(width: 250, height: 50)
                                .background(Color.mainSkyBlue)
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
            .onAppear {
                selectedBG = viewModel.cardModel.bgType
            }
        }
    }
}

//struct CardDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        CardDetailView(viewMode: .constant(.create),
//                       cardModel: .constant(CardModel(id: UUID().uuidString,
//                                                      cardType: "Master Card",
//                                                      userName: "Test User",
//                                                      cardNumber: "1234122333365545",
//                                                      bgType: BackgroundCardType(rawValue: "") ?? .default)))
//    }
//}

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
                    .foregroundColor(Color.imperialRed)
            })
        }
        .padding()
    }
}
