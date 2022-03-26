//
//  LoginRouter.swift
//  CardsBox
//
//  Created by Alexander Malygin on 12/11/21.
//

import Foundation
import SwiftUI

final class LoginRouter {
    public static func pushMainContainer() -> some View {
        return EmptyView()
    }
    
    public static func pushSignup() -> some View {
        return SignUpConfigurator.configureSignUpView()
    }
}
