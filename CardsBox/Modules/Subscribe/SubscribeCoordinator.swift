//
//  SubscribeCoordinator.swift
//  CardsBox
//
//  Created by Alexander Malygin on 5/26/22.
//  Copyright (c) 2022. All rights reserved.
//

import UIKit

class SubscribeCoordinator: BaseCoordinator {
    let router: RouterProtocol
    var controller: SubscribeViewController

    init(router: RouterProtocol) {
        self.router = router

        let viewModel = SubscribeViewModel()
        self.controller = SubscribeViewController(viewModel: viewModel)
    }

    override func start() {
        controller.viewModel.routes.backAction = { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.router.pop(true)
        }
    }
}

extension SubscribeCoordinator: Drawable {
    var viewController: UIViewController? { return controller }
}
