//
//  CardsBoxApp.swift
//  CardsBox
//
//  Created by Eugene Shapovalov on 01.06.2021.
//

import SwiftUI
import Firebase
import FirebaseAuth

@main
struct CardsBoxApp: App {
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            MainContentView()
                .onReceive(NotificationCenter.default.publisher(for: UIApplication.didEnterBackgroundNotification), perform: { output in
//                    logout()
                })
                .onReceive(NotificationCenter.default.publisher(for: UIApplication.willTerminateNotification), perform: { output in
                    logout()
                })
        }
    }
    
    private func logout() {
         try? Auth.auth().signOut()
         DataManager.shared.userProfile = nil
         Router.showMain()
     }
}
