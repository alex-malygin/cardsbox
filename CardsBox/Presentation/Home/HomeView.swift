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
}

struct HomeView: View {
    @ObservedObject var viewModel: HomeViewModel
    
    @State private var searchText = ""
    @State private var isShowingDetails = false
    @State private var showMenu = false
    @State private var isSelected: String? = nil
    @State private var sheetType: SheetType = .cardDetail
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    header
                    content()
                }
                ActivityIndicator(shouldAnimate: $viewModel.showLoader)
            }
            .background(Color.mainGrayColor)
            .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .automatic))
            .navigationBarHidden(true)
        }
        .navigationViewStyle(.stack)
        .onAppear {
            updateNavigationAppearance(main: true)
            viewModel.getCards()
            viewModel.getProfile()
        }
        .ignoresSafeArea(.container, edges: .bottom)
        .navigationTitle(Strings.mainTitle)
        .alert(isPresented: $viewModel.showAlert, content: {
            Alert(title: Text("Error"), message: Text($viewModel.errorText.wrappedValue), dismissButton: .cancel())
        })
        .sheet(isPresented: $viewModel.isShowingDetails) {
            showSheet()
        }
    }
    
    var searchResults: [CardModel] {
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
                Text("\(viewModel.profile?.userName ?? "") 👋")
                    .fontWeight(.bold)
            }
            Spacer()
            WebImageView(imageURL: viewModel.profile?.avatar, placeholder: viewModel.image, lineWidth: 4)
                .frame(width: 80, height: 80, alignment: .center)
                .onTapGesture {
                    sheetType = .profile
                    viewModel.isShowingDetails = true
                }
        }
        .padding(.horizontal)
        .redacted(reason: viewModel.profile == nil ? .placeholder : [])
    }
}

extension HomeView {
    private func content() -> some View {
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
                            viewModel.deleteCard(cardID: card.id)
                        } label: {
                            Text("Delete")
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
        }
    }
}

//extension HomeView {
//    private var trailingButton: some View {
//        Button(action: {
//            viewModel.mode = .create
//            viewModel.selectedCard = nil
//            viewModel.isShowingDetails = true
//        }, label: {
//            Image(systemName: "plus")
//                .font(.system(size: 20.0, weight: .medium))
//        })
//    }
//
//    private var leadingButton: some View {
//        Button(action: {
//            withAnimation(.spring(response: 0.3)) {
//                showMenu.toggle()
//            }
//        }, label: {
//            Image(systemName: "line.3.horizontal")
//                .font(.system(size: 20.0, weight: .medium))
//        })
//    }
//}



struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(viewModel: HomeViewModel(firestoreService: ServiceConfigurator.makeFirestoreService()))
    }
}
