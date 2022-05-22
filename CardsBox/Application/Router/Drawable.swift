//
//  Drawable.swift
//  CardsBox
//
//  Created by Alexander Malygin on 4/4/22.
//

import UIKit

protocol Drawable {
    var viewController: UIViewController? { get }
}

extension UIViewController: Drawable {
    var viewController: UIViewController? { return self }
}
