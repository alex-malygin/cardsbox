//
//  Router.swift
//  CardsBox
//
//  Created by Alexander Malygin on 4/4/22.
//

import UIKit

typealias NavigationBackClosure = EmptyClosure

protocol RouterProtocol: AnyObject {
    func push(_ drawable: Drawable, isAnimated: Bool, onNavigateBack: NavigationBackClosure?)
    func push(_ items: [(drawable: Drawable, backClosure: NavigationBackClosure?)], isAnimated: Bool)
    func switchTo(_ drawable: Drawable, isAnimated: Bool, onNavigateBack closure: NavigationBackClosure?)
    func pop(_ isAnimated: Bool)
    func popToRoot(_ isAnimated: Bool)
    var isNotRootViewController: Bool { get }
}

class Router: NSObject, RouterProtocol {
    let navigationController: UINavigationController
    private var closures = [String: NavigationBackClosure]()

    var isNotRootViewController: Bool {
        return navigationController.viewControllers.count > 1
    }

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        super.init()
        self.navigationController.delegate = self
    }

    deinit {
        debugPrint("DEINITED \(String(describing: self))")
    }

    func push(_ drawable: Drawable, isAnimated: Bool, onNavigateBack closure: NavigationBackClosure?) {
        guard let viewController = drawable.viewController else { return }

        if let closure = closure {
            closures.updateValue(closure, forKey: viewController.description)
        }
        self.navigationController.pushViewController(viewController, animated: isAnimated)
    }

    func push(_ items: [(drawable: Drawable, backClosure: NavigationBackClosure?)], isAnimated: Bool) {
        let viewControllers = items.compactMap { $0.drawable.viewController }
        items.forEach { item in
            if let closure = item.backClosure, let key = item.drawable.viewController?.description {
                closures.updateValue(closure, forKey: key)
            }
        }
        let currentControllers = navigationController.viewControllers
        self.navigationController.setViewControllers(currentControllers + viewControllers, animated: isAnimated)
    }

    func pop(_ isAnimated: Bool) {
        self.navigationController.popViewController(animated: isAnimated)
    }

    func popToRoot(_ isAnimated: Bool) {
        guard let viewControllers = navigationController.popToRootViewController(animated: isAnimated) else { return }
        viewControllers.forEach { executeClosure($0) }
    }

    func switchTo(_ drawable: Drawable, isAnimated: Bool, onNavigateBack closure: NavigationBackClosure?) {
        pop(false)
        push(drawable, isAnimated: isAnimated, onNavigateBack: closure)
    }

    private func executeClosure(_ viewController: UIViewController) {
        guard let closure = closures.removeValue(forKey: viewController.description) else { return }
        closure()
    }
}

extension Router: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        guard let previousController = navigationController.transitionCoordinator?.viewController(forKey: .from),
            !navigationController.viewControllers.contains(previousController) else {
                return
        }
        executeClosure(previousController)
    }
}

