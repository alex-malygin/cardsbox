//
//  AlertService.swift
//  CardsBox
//
//  Created by Alexander Malygin on 5/26/22.
//

import UIKit

struct AlertButton {
    enum ButtonType {
        case ok
        case cancel
        case no
        case title(_ title: String)
        case destructive(_ title: String)

        var string: String {
            switch self {
            case .ok: return Strings.actionOkTitle
            case .cancel: return Strings.alertCancelButtonTitle
            case .no: return Strings.alertNoText
            case .destructive(let title): return title
            case .title(let title): return title
            }
        }
    }

    let title: String
    let action: VoidClosure?
    let style: UIAlertAction.Style
    let image: UIImage?

    init(type: ButtonType, image: UIImage? = nil, action: VoidClosure? = nil) {
        self.action = action
        self.title = type.string
        self.image = image

        switch type {
        case .cancel, .no: style = .cancel
        case .destructive: style = .destructive
        default: style = .default
        }
    }
}

struct AlertTextField {
    let text: String?
    var placeholder: String?
    var contentType: UITextContentType?
    var keyboardType: UIKeyboardType = .default
    var isSecure = false
    let selector: Selector
    weak var target: AnyObject?
}

class AlertService {
    static let tintColor: UIColor = UIView().tintColor // default tint color

    private class func show(type: UIAlertController.Style = .alert,
                            title: String? = nil,
                            message: String? = nil,
                            buttons: [AlertButton] = [],
                            textFields: [AlertTextField] = [],

                            source: UIViewController? = nil,
                            targetView: UIView? = nil) {
        var alertController = UIAlertController(title: title, message: message, preferredStyle: type)
        alertController.view.tintColor = tintColor

        addButtons(buttons, alertController: &alertController)
        addTextFields(textFields, alertController: &alertController)
        presentAlert(alertController, source: source, targetView: targetView)

        // Print to console
        print("[\(Date())] [ALERT: \(title ?? "")\(message ?? "")]")
    }

    private class func addButtons(_ buttons: [AlertButton], alertController: inout UIAlertController) {
        if buttons.isEmpty {
            let button = AlertButton(type: .ok)
            alertController.addAction(UIAlertAction(title: button.title, style: .cancel, handler: nil))
            return
        }

        for button in buttons {
            let action = UIAlertAction(title: button.title, style: button.style, handler: { _ in
                button.action?()
            })
            let image = button.image
            action.setValue(image, forKey: "image")
            alertController.addAction(action)
        }
    }

    private class func addTextFields(_ textInputs: [AlertTextField], alertController: inout UIAlertController) {
        for textInput in textInputs {
            alertController.addTextField { textField in
                textField.text = textInput.text
                textField.keyboardType = textInput.keyboardType
                textField.placeholder = textInput.placeholder
                textField.textContentType = textInput.contentType
                textField.isSecureTextEntry = textInput.isSecure
                textField.addTarget(textInput.target, action: textInput.selector, for: .editingChanged)
            }
        }
    }

    private class func presentAlert(_ alertController: UIAlertController, source: UIViewController?, targetView: UIView?) {
        DispatchQueue.main.async {
            if let targetView = targetView {
                alertController.popoverPresentationController?.sourceView = targetView
//                alertController.popoverPresentationController?.sourceRect = targetView.bounds
            }
            if let controller = source {
                controller.present(alertController, animated: true, completion: nil)
            } else {
                UIApplication.shared.topController?.present(alertController, animated: true, completion: nil)
            }
        }
    }
}

extension AlertService {
    // MARK: - Alert View
    class func showAlertMessage(_ text: String?, title: String?, onController: UIViewController? = nil, handler: VoidClosure?) {
        AlertService.show(type: .alert, title: title, message: text, buttons: [AlertButton(type: .ok, action: handler)], source: onController)
    }

    class func showAlertMessageWithActionAndCancel(title: String? = nil,
                                                   text: String?,
                                                   okButtonText: String? = nil,
                                                   handler: VoidClosure?,
                                                   onController: UIViewController? = nil) {
        AlertService.show(title: title,
                          message: text,
                          buttons: [AlertButton(type: okButtonText == nil ? .ok : .title(okButtonText!), action: handler),
                                    AlertButton(type: .cancel)],
                          source: onController)
    }

    class func showAlertMessage(_ title: String?,
                                message: String?,
                                okButtonText: String? = nil,
                                isDestruct: Bool = false,
                                textField: AlertTextField,
                                handler: VoidClosure?,
                                onController: UIViewController? = nil) {
        AlertService.show(title: title, message: message,
                          buttons: [AlertButton(type: okButtonText == nil ? .ok : isDestruct ? .destructive(okButtonText!) : .title(okButtonText!),
                                                action: handler),
                                    AlertButton(type: .cancel)],
                          textFields: [textField], source: onController)
    }

    class func showAlertMessageWithActionAndCancelHandler(title: String? = nil,
                                                          text: String?,
                                                          okButtonText: String? = nil,
                                                          cancelHandler: VoidClosure?,
                                                          actionHandler: VoidClosure?,
                                                          onController: UIViewController? = nil) {
        AlertService.show(title: title,
                          message: text,
                          buttons: [AlertButton(type: okButtonText == nil ? .ok : .title(okButtonText!), action: actionHandler),
                                    AlertButton(type: .no, action: cancelHandler)],
                          source: onController)
    }

    class func showAlert(title: String?,
                         message: String?,
                         buttons: [AlertButton] = [],
                         textFields: [AlertTextField] = [],
                         onController: UIViewController? = nil) {
        AlertService.show(type: .alert, title: title, message: message, buttons: buttons, textFields: textFields, source: onController)
    }

    // MARK: - Sheet alert
    class func showSheetAlert(title: String?, message: String?, buttons: [AlertButton], onController: UIViewController? = nil, targetView: UIView?) {
        AlertService.show(type: .actionSheet, title: title, message: message, buttons: buttons, source: onController, targetView: targetView)
    }

    // One Time Alert Message
    class func showOneTimeAlert(_ title: String = "", message: String, key: String) {
        guard let _ = UserDefaults.standard.string(forKey: key) else {
            AlertService.show(title: title, message: message)
            UserDefaults.standard.set("done", forKey: key)
            return
        }
    }
}
