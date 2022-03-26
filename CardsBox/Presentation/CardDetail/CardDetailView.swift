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
    @Environment(\.presentationMode) var presentationMode
    @State private var isShowingSheet = false
    
    var body: some View {
        VStack(alignment: .leading) {
            HeaderCardDetailView(title: viewMode == .create ? Strings.createModeTitle : Strings.editModeTitle)
            ScrollView() {
                VStack(spacing: 25) {
                    Spacer()

                    ZStack(alignment: .trailing) {
                        CardView(cardType: .constant(viewModel.cardModel.cardType),
                                 cardNumber: $cardNumber,
                                 cardHolderName: $userName,
                                 backgroundType: $selectedBG)
                        
                        Button {
                            UIImpactFeedbackGenerator(style: .light).impactOccurred()
                            isShowingSheet = true
                        } label: {
                            Image(systemName: "camera.circle.fill")
                                .font(.system(size: 40.0, weight: .regular))
                                .foregroundColor(Color.mainGrayColor)
                        }
                        .padding(.trailing, 20)
                    }
                    
                    Spacer()
                    
                    VStack(spacing: 15) {
                        TextFieldView(placeholder: Strings.cardDetailCardNumberPlaceholder, text: $cardNumber, maxLenth: 16)
                            .onAppear() {
                                cardNumber = viewMode == .create ? "" : viewModel.cardModel.cardNumber
                            }
                            .onChange(of: cardNumber, perform: { newValue in
                                viewModel.cardModel.cardNumber = newValue
                            })
                            .keyboardType(.numberPad)
                        
                        TextFieldView(placeholder: Strings.cardDetailEnterNamePlaceholder, text: $userName, maxLenth: 25)
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
                        UIImpactFeedbackGenerator(style: .light).impactOccurred()
                        viewMode == .create ? viewModel.addCard() : viewModel.updateCard()
                        
                        viewModel.$isPresented.sink { presented in
                            if !presented {
                                presentationMode.wrappedValue.dismiss()
                            }
                        }.store(in: &viewModel.cancellable)
                        
                    }, label: {
                        Text( viewMode == .create ? Strings.mainAddNewButton : Strings.actionSaveTitle)
                            .fontWeight(.semibold)
                            .frame(width: UIScreen.screenWidth - 30,
                                   height: 50)
                            .background(Color.sky)
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
        .alert(isPresented: $viewModel.showAlert, content: {
            Alert(title: Text("Error"),
                  message: Text(viewModel.errorText),
                  dismissButton: .cancel())
        })
        .sheet(isPresented: $isShowingSheet) {
            CardReaderView() { cardDetails in
                print(cardDetails ?? "")
                viewModel.cardModel.cardNumber = cardDetails?.number ?? ""
                cardNumber = cardDetails?.number?.components(separatedBy: .whitespaces).joined() ?? ""
                isShowingSheet.toggle()
            }
            .edgesIgnoringSafeArea(.all)
        }
        .background(Color.mainGrayColor)
        .onAppear {
            selectedBG = viewModel.cardModel.bgType
        }
    }
}

struct CardDetailView_Previews: PreviewProvider {
    static var previews: some View {
        CardDetailView(viewModel: CardDetailViewModel(cardModel: nil),
                       viewMode: .constant(.create))
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
                UIImpactFeedbackGenerator(style: .light).impactOccurred()
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
