//
//  MainTabView.swift
//  CardsBox
//
//  Created by Alexander Malygin on 10/22/21.
//

import SwiftUI
import FirebaseAuth

struct MainTabView: View {
    enum Tab: String {
        case home = "Cards"
        case profile = "Profile"
    }
    @ObservedObject var viewModel = HomeViewModel()
    
    @State private var selectedTab: Tab = .home
    @State private var title: String = ""
    
    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView(viewModel: viewModel)
                .tabItem {
                    Label("Cards", systemImage: "creditcard.fill")
                }
                .tag(Tab.home)
            
            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person.fill")
                }
                .tag(Tab.profile)
        }
        .onAppear(perform: {
            title = selectedTab.rawValue
            updateNavigationAppearance(main: true)
        })
        .onChange(of: selectedTab, perform: { newValue in
            title = newValue.rawValue
        })
        .toolbar(content: {
            ToolbarItem(placement: .navigationBarTrailing) {
                switch selectedTab {
                case .home:
                    trailingButton
                case .profile:
                    EmptyView()
                }
            }
        })
        .ignoresSafeArea(.keyboard)
        .navigationBarHidden(false)
        .navigationTitle($title.wrappedValue)
        .navigationBarBackButtonHidden(true)
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private var trailingButton: some View {
        Button(action: {
            viewModel.mode = .create
            viewModel.selectedCard = CardModel(id: UUID().uuidString, cardType: "Master Card", userName: "", cardNumber: "", bgType: BackgroundCardType(rawValue: "") ?? .default)
            viewModel.isShowingDetails = true
        }, label: {
            Image(systemName: "plus")
                .font(.system(size: 22.0, weight: .medium))
        })
    }
}
