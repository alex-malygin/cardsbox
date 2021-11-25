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
    @StateObject var viewModelsFactory = ViewModelsFactory()
    @StateObject var viewModel = MainContentViewModel(dataManager: DataManager.shared)
    @Environment(\.scenePhase) private var scenePhase
    private var activeSessionManager = ActiveSessionManager(dataManager: DataManager.shared)
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            MainContentView()
                .environmentObject(viewModel)
                .environmentObject(viewModelsFactory)
                .onChange(of: scenePhase) { phase in
                    switch phase {
                    case .background:
                        activeSessionManager.setNewLastSessionTime()
                    case .inactive:
                        debugPrint("inactive")
                    case .active:
                        if activeSessionManager.checkLastSessionTime() {
                            viewModel.logout()
                        }
                    @unknown default:
                        break
                    }
                }
                .onReceive(NotificationCenter.default.publisher(for: UIApplication.willTerminateNotification),
                           perform: { output in
                    viewModel.logout()
                })
        }
    }
}
