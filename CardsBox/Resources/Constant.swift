//
//  Constant.swift
//  CardsBox
//
//  Created by Eugene Shapovalov on 8/13/21.
//

import UIKit
import SwiftUI

func updateNavigationAppearance(main: Bool) {
    if #available(iOS 15.0, *) {
        let appearance = main ? opaqueAppearance(backgroundColor: .navBarColor) : opaqueAppearance()
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        UINavigationBar.appearance().shadowImage = UIImage()
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
    }
    
    if #available(iOS 15.0, *) {
        let appearance = UITabBarAppearance()
        appearance.backgroundColor = .navBarColor
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }
}

func opaqueAppearance(backgroundColor: UIColor = .clear) -> UINavigationBarAppearance {
    let appearance = UINavigationBarAppearance()
    appearance.configureWithOpaqueBackground()
    appearance.backgroundColor = backgroundColor
    appearance.shadowColor = backgroundColor == .clear ? .clear : .separator
    appearance.shadowImage = nil
    return appearance
}
