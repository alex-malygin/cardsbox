//
//  MainTabView.swift
//  CardsBox
//
//  Created by Alexander Malygin on 10/22/21.
//

import SwiftUI

struct MainTabView: View {
    enum Tab {
        case home, profile
    }
    @ObservedObject var viewModel = HomeViewModel()
    
    @State private var selectedTab: Tab = .home
    @State private var title: String = ""
    
    var body: some View {
        TabView {
            HomeView(viewModel: viewModel)
                .onAppear(perform: {
                    selectedTab = .home
                    title = Strings.mainTitle
                })
                .tabItem {
                    Label("Cards", systemImage: "creditcard.fill")
                }
            
            ProfileView()
                .onAppear(perform: {
                    selectedTab = .profile
                    title = "Profile"
                })
                .tabItem {
                    Label("Profile", systemImage: "person.fill")
                }
        }
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
        .navigationTitle($title.wrappedValue)
        .navigationBarBackButtonHidden(true)
    }
    
    private var trailingButton: some View {
        Button(action: {
            viewModel.mode = .create
            viewModel.selectedCard = CardModel(id: UUID(), cardType: "Master Card", userName: "", cardNumber: "", bgType: .default)
            viewModel.isShowingDetails = true
        }, label: {
            Image(systemName: "plus")
                .font(.system(size: 22.0, weight: .medium))
        })
    }
}
