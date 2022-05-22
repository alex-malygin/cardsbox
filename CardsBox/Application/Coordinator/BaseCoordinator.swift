//
//  BaseCoordinator.swift
//  CardsBox
//
//  Created by Alexander Malygin on 4/4/22.
//

import Foundation

protocol Coordinator: AnyObject {
    var childCoordinators: [Coordinator] { get set }
    func childCoordinator<T>(cls: T.Type) -> T?
    func start()
}

extension Coordinator {
    func store(coordinator: Coordinator) {
        childCoordinators.append(coordinator)
        debugPrint("STORE \(String(describing: coordinator))")
    }

    func free(coordinator: Coordinator) {
        childCoordinators = childCoordinators.filter { $0 !== coordinator }
        debugPrint("FREE \(String(describing: coordinator))")
    }
}

class BaseCoordinator: NSObject, Coordinator {
    var childCoordinators = [Coordinator]()
    var isCompleted: EmptyClosure?

    func start() {
        fatalError("Children should implement `start`.")
    }

    func childCoordinator<T>(cls: T.Type) -> T? {
        var found: T?
        childCoordinators.forEach {
            if $0 is T {
                found = $0 as? T
                return
            } else if !$0.childCoordinators.isEmpty {
                if let result = $0.childCoordinator(cls: cls) {
                    found = result
                    return
                }
            }
        }
        return found
    }

    deinit {
        debugPrint("DEINITED \(String(describing: self))")
    }
}
