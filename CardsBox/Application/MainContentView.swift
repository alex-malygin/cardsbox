//
//  MainContentView.swift
//  CardsBox
//
//  Created by Alexander Malygin on 10/26/21.
//

import SwiftUI
import FirebaseAuth

struct MainContentView: View {
    private let databaseManager = DatabaseManager.shared
    
    init() {
        databaseManager.getUserProfile(userID: Auth.auth().currentUser?.uid)
    }
    
    var body: some View {
        NavigationView {
            if Auth.auth().currentUser == nil {
                LoginView()
                    .navigationViewStyle(.stack)
                    .navigationBarTitleDisplayMode(.inline)
                    .ignoresSafeArea(.keyboard)
            } else {
                MainTabView()
                    .navigationViewStyle(.stack)
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
