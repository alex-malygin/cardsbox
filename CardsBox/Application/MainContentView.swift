//
//  MainContentView.swift
//  CardsBox
//
//  Created by Alexander Malygin on 10/26/21.
//

import SwiftUI

struct MainContentView: View {
    
    @State var auth: Bool = true
    
    var body: some View {
        NavigationView {
            if auth {
                MainTabView()
                    .navigationViewStyle(.stack)
                    .navigationBarTitleDisplayMode(.inline)
                    .ignoresSafeArea(.keyboard)
            } else {
                LoginView()
                    .navigationViewStyle(.stack)
                    .navigationBarTitleDisplayMode(.inline)
                    .ignoresSafeArea(.keyboard)
            }   
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
    }
}

struct MainContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainContentView()
    }
}
