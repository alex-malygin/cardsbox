//
//  AppDelegate+Extension.swift
//  CardsBox
//
//  Created by Alexander Malygin on 4/4/22.
//

import UIKit

extension UIApplication {
    var topController: UIViewController? {
        if var controller = UIWindow.main.rootViewController {
            while let presentedViewController = controller.presentedViewController {
                controller = presentedViewController
            }
            return controller
        }
        return nil
    }
}

// MARK: - UIWindow
extension UIWindow {
    static var main: UIWindow {
        if #available(iOS 13, *) {
            return UIApplication.shared.connectedScenes
                .compactMap { $0 as? UIWindowScene }
                .flatMap { $0.windows }
                .first(where: { $0.isKeyWindow })!
        } else {
            return UIApplication.shared.keyWindow!
        }
    }
}
