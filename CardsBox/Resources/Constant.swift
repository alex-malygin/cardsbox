//
//  Constant.swift
//  CardsBox
//
//  Created by Eugene Shapovalov on 8/13/21.
//

import UIKit
import SwiftUI

func updateNavigationAppearance(main: Bool, clear: Bool = false) {
    if #available(iOS 15.0, *) {
        let appearance = main ? opaqueAppearance(backgroundColor: .navBarColor) : opaqueAppearance(clear: clear)
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        UINavigationBar.appearance().shadowImage = UIImage()
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
    }
}

func opaqueAppearance(backgroundColor: UIColor = .systemBackground, clear: Bool = false) -> UINavigationBarAppearance {
    let appearance = UINavigationBarAppearance()
    appearance.configureWithOpaqueBackground()
    appearance.backgroundColor = clear ? .clear : backgroundColor
    appearance.shadowColor = clear ? .clear : nil
    appearance.shadowImage = nil
    return appearance
}
