//
//  ModalRouter.swift
//  CardsBox
//
//  Created by Alexander Malygin on 4/4/22.
//

import UIKit

typealias ModalCloseClosure = EmptyClosure

protocol RouterModalProtocol: AnyObject {
    func present(_ drawable: Drawable, isAnimated: Bool, onClose closure: ModalCloseClosure?)
    func dismiss(_ drawable: Drawable, isAnimated: Bool)
}

class RouterModal: NSObject, RouterModalProtocol {
    private let rootController: UIViewController?
    private var closure: ModalCloseClosure?

    init(root drawable: Drawable) {
        self.rootController = drawable.viewController
    }

    deinit {
        debugPrint("DEINITED \(String(describing: self))")
    }

    func present(_ drawable: Drawable, isAnimated: Bool, onClose closure: ModalCloseClosure?) {
        guard let viewController = drawable.viewController else { return }
        viewController.presentationController?.delegate = self
        self.closure = closure

        rootController?.present(viewController, animated: isAnimated, completion: nil)
    }

    func dismiss(_ drawable: Drawable, isAnimated: Bool) {
        guard let viewController = drawable.viewController else { return }

        viewController.dismiss(animated: isAnimated) { [weak self] in
            self?.closure?()
        }
    }
}

extension RouterModal: UIAdaptivePresentationControllerDelegate {
    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        closure?()
    }
}
