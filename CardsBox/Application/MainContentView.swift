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
 
    var body: some View {
        NavigationView {
            if settings.isLogin {
                MainContainer()
            } else {
                LoginView()
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
