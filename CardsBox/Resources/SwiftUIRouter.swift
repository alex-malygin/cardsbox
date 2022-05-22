//
//  Router.swift
//  CardsBox
//
//  Created by Alexander Malygin on 11/4/21.
//

import Foundation
import UIKit
import SwiftUI

class SwiftUIRouter {
    
    static func showMain() {
        let window = UIApplication
            .shared
            .connectedScenes
            .flatMap { ($0 as? UIWindowScene)?.windows ?? [] }
            .first { $0.isKeyWindow }
            window?.rootViewController = UIHostingController(rootView: MainContentView())
    }
}
