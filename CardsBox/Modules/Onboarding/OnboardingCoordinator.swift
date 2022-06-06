//
//  OnboardingCoordinator.swift
//  CardsBox
//
//  Created by Alexander Malygin on 5/26/22.
//  Copyright (c) 2022. All rights reserved.
//

import UIKit

class OnboardingCoordinator: BaseCoordinator {
    let router: RouterProtocol
    var controller: OnboardingViewController

    init(router: RouterProtocol) {
        self.router = router

        let viewModel = OnboardingViewModel()
        self.controller = OnboardingViewController(viewModel: viewModel)
    }

    override func start() {
        controller.viewModel.routes.backAction = { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.router.pop(true)
        }
    }
}

extension OnboardingCoordinator: Drawable {
    var viewController: UIViewController? { return controller }
}
