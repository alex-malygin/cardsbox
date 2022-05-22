//
//  LoginConfigurator.swift
//  CardsBox
//
//  Created by Alexander Malygin on 12/11/21.
//

import Foundation

final class LoginConfigurator {
    public static func configureLoginView() -> LoginView {
        let viewModel = OldLoginViewModel(authService: ServiceConfigurator.makeAuthService())
        let view = LoginView(viewModel: viewModel)
        return view
    }
}
