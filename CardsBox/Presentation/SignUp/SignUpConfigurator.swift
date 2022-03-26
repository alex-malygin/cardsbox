//
//  SignUpConfigurator.swift
//  CardsBox
//
//  Created by Alexander Malygin on 12/11/21.
//

import Foundation

final class SignUpConfigurator {
    public static func configureSignUpView() -> SignUpView {
        let viewModel = SignUpViewModel(authService: ServiceConfigurator.makeAuthService())
        let view = SignUpView(viewModel: viewModel)
        return view
    }
}
