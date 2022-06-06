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
    private let viewModel: LoginViewModelType
    
    init(router: RouterProtocol) {
        self.router = router
        viewModel = LoginViewModel()
        controller = LoginViewController(viewModel: viewModel)
    }
    
    override func start() {
        viewModel.output.showMain = { [weak self] in
            self?.showMain()
        }
    }
    
    private func showMain() {
        let app = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate
        app?.appCoordinator?.start()
    }
}

extension LoginCoordinator: Drawable {
    var viewController: UIViewController? { return controller }
}
