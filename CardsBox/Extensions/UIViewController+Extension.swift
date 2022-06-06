//
//  UIViewController+Extension.swift
//  CardsBox
//
//  Created by Alexander Malygin on 5/26/22.
//

import UIKit

// MARK: - Alerts
extension UIViewController {
    func showAlert(message: String?, handler: VoidClosure? = nil) {
        AlertService.showAlertMessage(message, title: nil, onController: self, handler: handler)
    }
    func showAlertWithCancel(message: String?, okTitle: String? = nil, handler: VoidClosure? = nil) {
        AlertService.showAlertMessageWithActionAndCancel(title: nil, text: message, okButtonText: okTitle, handler: handler, onController: self)
    }
    func showAlertSheet(title: String?, message: String?, buttons: [AlertButton], targetView: UIView?) {
        AlertService.showSheetAlert(title: title, message: message, buttons: buttons, onController: self, targetView: targetView)
    }
    func showAlert(title: String?, message: String?, buttons: [AlertButton] = [], textFields: [AlertTextField] = [], controller: UIViewController?) {
        AlertService.showAlert(title: title, message: message, buttons: buttons, textFields: textFields, onController: controller ?? self)
    }
    func showAlertWithActionAndCancelHandler(message: String?, okTitle: String? = nil, text: String? = nil,
                                             cancelHandler: VoidClosure?, actionHandler: VoidClosure? = nil) {
        AlertService.showAlertMessageWithActionAndCancelHandler(title: message, text: text, okButtonText: okTitle,
                                                                cancelHandler: cancelHandler, actionHandler: actionHandler, onController: self)
    }
}
