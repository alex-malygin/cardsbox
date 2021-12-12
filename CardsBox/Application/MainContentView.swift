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
    
    init() {
        UITableView.appearance().backgroundColor = .clear
        UITableView.appearance().showsVerticalScrollIndicator = false
    }
    
    var body: some View {
        if settings.isLogin {
            HomeConfigurator.configureHomeView()
        } else {
            LoginConfigurator.configureLoginView()
        }
    }
}

struct MainContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainContentView()
    }
}
