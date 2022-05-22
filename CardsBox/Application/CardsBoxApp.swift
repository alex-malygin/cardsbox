//
//  CardsBoxApp.swift
//  CardsBox
//
//  Created by Eugene Shapovalov on 01.06.2021.
//

import SwiftUI
import Firebase
import FirebaseAuth

struct CardsBoxApp: App {
    @StateObject var mainViewModel = MainContentViewModel()
    @Environment(\.scenePhase) private var scenePhase
    private var activeSessionManager = ActiveSessionManager()
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            MainContentView()
                .environmentObject(mainViewModel)
                .onChange(of: scenePhase) { phase in
                    switch phase {
                    case .background:
                        debugPrint("background")
                        activeSessionManager.setNewLastSessionTime()
                    case .inactive:
                        debugPrint("inactive")
                    case .active:
                        debugPrint("active")
                        if activeSessionManager.checkLastSessionTime() {
                            logout()
                        }
                    @unknown default:
                        break
                    }
                }
                .onReceive(NotificationCenter.default.publisher(for: UIApplication.willTerminateNotification),
                           perform: { output in
                    logout()
                })
        }
    }
    
    private func logout() {
        try? Auth.auth().signOut()
        DataManager.shared.userProfile = nil
        DataManager.shared.lastActiveDate = 0
        mainViewModel.isLogin = false
    }
}
