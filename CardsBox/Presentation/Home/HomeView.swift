//
//  HomeView.swift
//  CardsBox
//
//  Created by Eugene Shapovalov on 01.06.2021.
//

import SwiftUI
import FirebaseAuth
import Combine

private enum SheetType {
    case cardDetail
    case profile
    case shareCard
}

struct HomeView: View {
    @ObservedObject var viewModel: HomeViewModel
    @State private var searchText = ""
    @State private var showMenu = false
    @State private var sheetType: SheetType = .cardDetail
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack(spacing: 0) {
                    header
                    SearchBar(text: $searchText)
                        .padding(.bottom, 10)
                        .padding(.horizontal, 3)
                    content
                    addCard
                }
                
                ActivityIndicator(shouldAnimate: $viewModel.showLoader)
            }
            .background(Color.mainGrayColor)
            .searchable(text: $searchText,
                        placement: .navigationBarDrawer(displayMode: .automatic))
            .navigationBarHidden(true)
            .navigationBarBackButtonHidden(true)
        }
        .navigationViewStyle(.stack)
        .onAppear {
            updateNavigationAppearance(main: true)
            viewModel.getCards()
            viewModel.getProfile()
        }
        .ignoresSafeArea(.all)
        .navigationTitle(Strings.mainTitle)
        .alert(isPresented: $viewModel.showAlert, content: {
            Alert(title: Text("Error"), message: Text($viewModel.errorText.wrappedValue), dismissButton: .cancel())
        })
        .sheet(isPresented: $viewModel.isShowingDetails) {
            showSheet()
        }
    }
    
    private var searchResults: [CardModel] {
        if searchText.isEmpty {
            return viewModel.cardList
        } else {
            return viewModel.cardList.filter { $0.userName.contains(searchText) }
        }
    }
}

extension HomeView {
    private var header: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("Welcome back!")
                    .font(.caption)
                    .foregroundColor(.headerLabel)
                Text("\(viewModel.profile?.userName ?? "") ????")
                    .fontWeight(.bold)
            }
            Spacer()
            WebImageView(imageURL: viewModel.profile?.avatar, placeholder: viewModel.image, lineWidth: 3)
                .frame(width: 80, height: 80, alignment: .center)
                .onTapGesture {
                    sheetType = .profile
                    viewModel.isShowingDetails = true
                }
        }
        .padding(.leading)
        .padding(.vertical, 3)
        .redacted(reason: viewModel.profile == nil ? .placeholder : [])
    }
}

extension HomeView {
    private var addCard: some View {
        VStack {
            HStack {
                
            }
            .frame(width: UIScreen.screenWidth, height: 1, alignment: .center)
            .background(Color.opaqueSeparator)
            
            Text(Strings.mainAddNewButton)
                .font(Font.system(size: 17))
                .fontWeight(.semibold)
                .frame(width: UIScreen.screenWidth - 30,
                       height: 50,
                       alignment: .center)
                .foregroundColor(.white)
                .background(Color.sky)
                .cornerRadius(10)
                .padding(.top, 10)
                .onTapGesture {
                    UIImpactFeedbackGenerator(style: .light).impactOccurred()
                    viewModel.mode = .create
                    viewModel.selectedCard = nil
                    viewModel.isShowingDetails = true
                    sheetType = .cardDetail
                }
        }
    }
}

extension HomeView {
    private var content: some View {
        List(searchResults, id: \.id) { card in
            Button(action: {
                viewModel.selectedCard = card
                viewModel.mode = .edit
                sheetType = .cardDetail
                viewModel.isShowingDetails = true
            }) {
                CardView(cardType: .constant(card.cardType),
                         cardNumber: .constant(card.cardNumber),
                         cardHolderName: .constant(card.userName),
                         backgroundType: .constant(card.bgType))
                    .contextMenu {
                        Button {
                            UINotificationFeedbackGenerator().notificationOccurred(.success)
                            UIPasteboard.general.setValue(card.cardNumber, forPasteboardType: "public.plain-text")
                        } label: {
                            Label("Copy", systemImage: "doc.text.fill")
                        }

                        Button {
                            viewModel.shareItems = [card.userName, card.cardNumber]
                            sheetType = .shareCard
                            viewModel.isShowingDetails = true
                        } label: {
                            Label("Share", systemImage: "square.and.arrow.up.fill")
                        }
                        
                        Button(role: .destructive) {
                            viewModel.deleteCard(cardID: card.id)
                        } label: {
                            Label("Delete", systemImage: "trash.fill")
                        }
                    }
            }
            .listRowBackground(Color.clear)
            .listRowSeparator(.hidden)
            .buttonStyle(PlainButtonStyle())
        }
        .listStyle(PlainListStyle())
    }
}

extension HomeView {
    private func showSheet() -> AnyView {
        switch sheetType {
        case .cardDetail:
            return AnyView(HomeRouter.showCardDetail(cardModel: viewModel.selectedCard, viewMode: $viewModel.mode))
        case .profile:
            return AnyView(LeftMenuConfigurator.configureLeftMenu())
        case .shareCard:
            return AnyView(ShareCardController(activityItems: viewModel.shareItems))
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(viewModel: HomeViewModel(firestoreService: ServiceConfigurator.makeFirestoreService()))
    }
}
