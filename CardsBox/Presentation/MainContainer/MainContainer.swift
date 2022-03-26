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
    @ObservedObject var viewModel: MainContainerViewModel
    
    @State private var showMenu = false
    
    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    HomeConfigurator.configureHomeView()
                        .frame(width: geometry.size.width, height: geometry.size.height)
                        .disabled(showMenu ? true : false)
                    
                    LeftMenuConfigurator.configureLeftMenu()
                        .frame(width: geometry.size.width / 1.3)
                        .offset(x: showMenu ? 0 : -geometry.size.width / 1.3,
                                y: 0)
                }
                .gesture(DragGesture()
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
                
            }
            .navigationBarBackButtonHidden(true)
            .navigationBarTitleDisplayMode(.inline)
        }
        .navigationViewStyle(.stack)
    }
}

//struct MainContainer_Previews: PreviewProvider {
//    static var previews: some View {
//        MainContainer()
//    }
//}
