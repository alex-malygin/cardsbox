//
//  Constant.swift
//  CardsBox
//
//  Created by Eugene Shapovalov on 8/13/21.
//

import UIKit
import SwiftUI

typealias EmptyClosure = (() -> Void)
typealias ItemClosure<T> = ((T) -> Void)
typealias OptionalItemClosure<T> = ((T?) -> Void)
typealias VoidClosure = (() -> Void)
typealias ResponseClosure<T> = ((_ object: T?, _ error: Error?) -> Void)

let baseAppRefreshAnimation: TimeInterval = 0.3
let screenHeight: CGFloat = UIScreen.main.bounds.height
let screenWidth: CGFloat = UIScreen.main.bounds.width

func updateNavigationAppearance(main: Bool, clear: Bool = false) {
    if #available(iOS 15.0, *) {
        let appearance = main ? opaqueAppearance(backgroundColor: .navBarColor) : opaqueAppearance(clear: clear)
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        UINavigationBar.appearance().shadowImage = UIImage()
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
        UINavigationBar.appearance().tintColor = .mainPurpure
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
