//
//  MainContainer.swift
//  CardsBox
//
//  Created by Alexander Malygin on 10/22/21.
//

import SwiftUI
import FirebaseAuth
import Combine

struct MainContainer: View {
    @ObservedObject private var viewModel = MainContainerViewModel()
    @ObservedObject private var homeViewModel = HomeViewModel()
    @ObservedObject private var leftMenuViewModel = LeftMenuViewModel()
    
    @State private var showMenu = false
    
    init() {
        UITableView.appearance().backgroundColor = .systemBackground
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                HomeView(viewModel: homeViewModel)
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .disabled(showMenu ? true : false)
                    .onTapGesture {
                        withAnimation {
                            showMenu = false
                        }
                    }
                
                if showMenu {
                    LeftMenu(viewModel: leftMenuViewModel)
                        .frame(width: geometry.size.width / 1.3)
                }
            }
            .gesture(DragGesture()
                        .onEnded {
                if $0.translation.width < -100 {
                    withAnimation {
                        showMenu = false
                    }
                }
            })
            .toolbar(content: {
                ToolbarItem(placement: .navigationBarTrailing) {
                    trailingButton
                }
                
                ToolbarItem(placement: .navigationBarLeading) {
                    leadingButton
                }
            })
            .onAppear {
                updateNavigationAppearance(main: true)
            }
            .navigationBarBackButtonHidden(true)
            .navigationBarTitleDisplayMode(.inline)
            .navigationViewStyle(.stack)
        }
    }
    
    private var trailingButton: some View {
        Button(action: {
            homeViewModel.mode = .create
            homeViewModel.selectedCard = nil
            homeViewModel.isShowingDetails = true
        }, label: {
            Image(systemName: "plus")
                .font(.system(size: 20.0, weight: .medium))
        })
    }
    
    private var leadingButton: some View {
        Button(action: {
            withAnimation {
                showMenu.toggle()
            }
        }, label: {
            Image(systemName: "line.3.horizontal")
                .font(.system(size: 20.0, weight: .medium))
        })
    }
}
