//
//  MainContentView.swift
//  CardsBox
//
//  Created by Alexander Malygin on 10/26/21.
//

import SwiftUI
import FirebaseAuth

struct MainContentView: View {
    @EnvironmentObject var settings: MainContentViewModel
    @EnvironmentObject var viewModels: ViewModelsFactory
 
    var body: some View {
        NavigationView {
            if settings.isLogin {
                MainContainer(viewModel: viewModels.makeMainContainerViewModel(),
                              homeViewModel: viewModels.makeHomeViewModel(),
                              leftMenuViewModel: viewModels.makeLeftMenuViewModel())
            } else {
                LoginView(viewModel: viewModels.makeLoginViewModel())
            }
        }
        .navigationViewStyle(.stack)
    }
}

struct MainContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainContentView()
    }
}
