//
//  MainContentView.swift
//  CardsBox
//
//  Created by Alexander Malygin on 10/26/21.
//

import SwiftUI
import FirebaseAuth

struct MainContentView: View {
 
    var body: some View {
        NavigationView {
            if Auth.auth().currentUser == nil {
                LoginView()
            } else {
                MainContainer()
            }
        }
    }
}

struct MainContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainContentView()
    }
}
