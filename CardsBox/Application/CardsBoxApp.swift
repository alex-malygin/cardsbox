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
        }
    }
}
