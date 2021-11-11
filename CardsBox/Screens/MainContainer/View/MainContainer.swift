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
                
                    LeftMenu(viewModel: leftMenuViewModel)
                        .frame(width: geometry.size.width / 1.3)
                        .offset(x: showMenu ? 0 : -geometry.size.width / 1.3,
                                y: 0)
            }
            .gesture(DragGesture(minimumDistance: 0, coordinateSpace: .local)
                                .onEnded({ value in
                                    if value.translation.width < 0 {
                                        withAnimation(.spring(response: 0.3)) {
                                            showMenu = false
                                        }
                                    }

                                    if value.translation.width > 0 {
                                        withAnimation(.spring(response: 0.3)) {
                                            showMenu = true
                                        }
                                    }
                                }))
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
            withAnimation(.spring(response: 0.3)) {
                showMenu.toggle()
            }
        }, label: {
            Image(systemName: "line.3.horizontal")
                .font(.system(size: 20.0, weight: .medium))
        })
    }
}

struct MainContainer_Previews: PreviewProvider {
    static var previews: some View {
        MainContainer()
    }
}
