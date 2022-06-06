//
//  AppCoordinator.swift
//  CardsBox
//
//  Created by Alexander Malygin on 3/29/22.
//

import UIKit

class AppCoordinator: BaseCoordinator {
    let window: UIWindow

    init(_ window: UIWindow) {
        self.window = window
        super.init()
    }
    
    override func start() {
        handleStartFlow()
    }
    
    private func handleStartFlow() {
        showFlow(isAuth: true)
    }
    
    private func showFlow(isAuth: Bool) {
        isAuth ? showAuthFlow() : showOnboardingFlow()
    }
    
    private func showAuthFlow() {
        childCoordinators = []
        
        let navigationController = UINavigationController()
        let router = Router(navigationController: navigationController)
        let coordinator = LoginCoordinator(router: router)
        
        store(coordinator: coordinator)
        coordinator.start()
        
        router.push(coordinator, isAnimated: true) { [weak self, weak coordinator] in
            guard let strongSelf = self, let coordinator = coordinator else { return }
            strongSelf.free(coordinator: coordinator)
        }
        setRoot(navigationController)
    }
    
    private func showOnboardingFlow() {
        childCoordinators = []
        
        let navigationController = UINavigationController()
        let router = Router(navigationController: navigationController)
        let coordinator = OnboardingCoordinator(router: router)
        
        store(coordinator: coordinator)
        coordinator.start()
        
        router.push(coordinator, isAnimated: true) { [weak self, weak coordinator] in
            guard let strongSelf = self, let coordinator = coordinator else { return }
            strongSelf.free(coordinator: coordinator)
        }
        setRoot(navigationController)
    }
}


extension AppCoordinator {
    private func set(_ controller: UIViewController) {
        window.rootViewController = controller
        window.makeKeyAndVisible()
    }

    private func setRoot(_ controller: UIViewController) {
        if window.rootViewController == nil {
            set(controller)
            return
        }

        let snapshot = UIWindow.main.snapshotView(afterScreenUpdates: true)!
        controller.view.addSubview(snapshot)
        UIWindow.main.rootViewController = controller
        UIView.transition(with: snapshot, duration: baseAppRefreshAnimation, options: .transitionCrossDissolve, animations: {
            snapshot.layer.opacity = .zero
            snapshot.layer.transform = CATransform3DMakeScale(1.3, 1.3, 1.3)
        }, completion: { _ in
            snapshot.removeFromSuperview()
        })
    }
}
