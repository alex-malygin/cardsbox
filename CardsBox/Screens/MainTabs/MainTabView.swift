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
    
    var body: some View {
        TabView {
            HomeView(viewModel: viewModel)
                .tabItem {
                    Label("Cards", systemImage: "creditcard.fill")
                }
            
            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person.fill")
                }
        }
        .toolbar(content: {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    viewModel.mode = .create
                    viewModel.selectedCard = CardModel(id: UUID(), cardType: "Master Card", userName: "", cardNumber: "", bgType: .default)
                    viewModel.isShowingDetails = true
                }, label: {
                    Image(systemName: "plus")
                        .font(.system(size: 22.0, weight: .medium))
                })
            }
        })
        .navigationTitle("123")
        .navigationBarBackButtonHidden(true)
    }
}
