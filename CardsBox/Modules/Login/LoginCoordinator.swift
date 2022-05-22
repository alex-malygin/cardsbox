//
//  LoginCoordinator.swift
//  CardsBox
//
//  Created by Alexander Malygin on 4/4/22.
//

import UIKit

final class LoginCoordinator: BaseCoordinator {
    private let router: RouterProtocol
    private let controller: LoginViewController
    private let viewModel: LoginViewModel
    
    init(router: RouterProtocol) {
        self.router = router
        viewModel = LoginViewModel()
        controller = LoginViewController(viewModel: viewModel)
    }
    
    override func start() {
        
    }
}

extension LoginCoordinator: Drawable {
    var viewController: UIViewController? { return controller }
}
