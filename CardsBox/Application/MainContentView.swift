//
//  MainContentView.swift
//  CardsBox
//
//  Created by Alexander Malygin on 10/26/21.
//

import SwiftUI
import FirebaseAuth

struct MainContentView: View {
    @State var auth: Bool = false
    
    init() {
        debugPrint(Auth.auth().currentUser?.displayName)
    }
    
    var body: some View {
        NavigationView {
            if auth {
                MainTabView()
                    .navigationViewStyle(.stack)
                    .ignoresSafeArea(.keyboard)
            } else {
                LoginView()
                    .navigationViewStyle(.stack)
                    .navigationBarTitleDisplayMode(.inline)
                    .ignoresSafeArea(.keyboard)
            }   
        }
    }
}

struct MainContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainContentView()
    }
}
