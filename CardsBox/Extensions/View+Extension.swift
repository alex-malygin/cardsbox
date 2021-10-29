//
//  View+Extension.swift
//  CardsBox
//
//  Created by Eugene Shapovalov on 8/13/21.
//

import SwiftUI

extension View {
    
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    func gradientForeground(colors: [Color]) -> some View {
        self.overlay(LinearGradient(gradient: .init(colors: colors),
                                    startPoint: .bottom,
                                    endPoint: .top))
            .mask(self)
    }
}

func updateNavigationAppearance() {
    let appearance = UINavigationBarAppearance()
    appearance.configureWithOpaqueBackground()
    
    UINavigationBar.appearance().isTranslucent = true
    UINavigationBar.appearance().scrollEdgeAppearance = appearance
}
