//
//  BaseView.swift
//  CardsBox
//
//  Created by Alexander Malygin on 5/20/22.
//

import UIKit

protocol Reusable {
    func prepareForReuse()
    func didEndDisplaying()
    func willDisplay()
}

class ReusableView: UIView, Reusable {
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

//    deinit {
//        debugPrint("DEINITED REUSABLE VIEW \(String(describing: self))")
//    }

    fileprivate func commonInit() {
        setupView()
    }

    func setupView() {
        // Implement in child classes
    }

    func prepareForReuse() {
        // Implement in child classes
    }

    func didEndDisplaying() {
        // Implement in child classes
    }

    func willDisplay() {
        // Implement in child classes
    }
}

class BaseView: ReusableView {
    var nibView: UIView!

    override func commonInit() {
        nibView = loadNib()
        nibView.frame = bounds
        nibView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        nibView.backgroundColor = backgroundColor
        addSubview(nibView)

        setupView()
    }
}
