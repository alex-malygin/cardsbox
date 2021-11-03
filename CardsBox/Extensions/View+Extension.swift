//
//  View+Extension.swift
//  CardsBox
//
//  Created by Eugene Shapovalov on 8/13/21.
//

import SwiftUI
import UIKit

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

func updateNavigationAppearance(main: Bool) {
    if #available(iOS 15.0, *) {
        let appearance = main ? opaqueAppearance(backgroundColor: .systemGray6) : opaqueAppearance()
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        UINavigationBar.appearance().shadowImage = UIImage()
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
    }
    
    if #available(iOS 15.0, *) {
        let appearance = UITabBarAppearance()
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }
}

func opaqueAppearance(backgroundColor: UIColor = .clear) -> UINavigationBarAppearance {
    let appearance = UINavigationBarAppearance()
    appearance.configureWithOpaqueBackground()
    appearance.backgroundColor = backgroundColor
    appearance.shadowColor = backgroundColor == .clear ? .clear : .systemGray
    appearance.shadowImage = nil
    return appearance
}
